// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery3
//= require foundation
//= require_tree .

$(document).on('turbolinks:load', function() {
  // Initialize Zurb Foundation JS
  $(document).foundation();
  // getEstimateForTransactionPurpose(); TODO: Make it working on page load/reload
  // Remote modal with AJAX and Reveal
  $('body').on('click', '[data-open="ajax-reveal"]', function(e) {
    e.preventDefault();
    $('.reveal-content').html('<div class="loader"></div>');
    $.ajax({
      url: $(this).data('url'),
      success: function(result) {
        $('.reveal-content').html(result);
      },
      error: function(result) {
        $('.reveal-content').html('Error loading content. Please close popup and retry.');
      }
    });
  });
  // Recurrence Rule Section: Toggling as per type
  $('.reveal-content').on('change', 'select#recurrence_rule_type', function(e) {
    $('#weekly, #monthly, #yearly').addClass('hide');
    $('#weekly, #monthly, #yearly').find('select, input').prop('disabled', true);
    $('#' + $(this).val().toLowerCase()).removeClass('hide');
    if($(this).val().toLowerCase() == 'yearly') {
      $('.month.1').removeClass('hide');
      $('#yearly input[name=day_of_month_or_week_yearly]:checked').each(function(e) {
        $('#yearly').find('input[type=radio]').attr('disabled', false);
        $('#yearly').find('.' + $(this).val()).find('select, input').attr('disabled', false);
      });
    } else if($(this).val().toLowerCase() == 'monthly') {
      $('#monthly').find('select, input').attr('disabled', false);
      toggleMonthlyDayOfMonthOrWeek($('#monthly input[name=day_of_month_or_week_monthly]').val());
    } else {
      $('#' + $(this).val().toLowerCase()).find('select, input').attr('disabled', false);
    }
    $('#interval-unit').text($(this).val().toLowerCase().replace(/i/, 'y').replace(/ly$/, '(s)'));
  });
  // Monthly Rule Section: toggling as per radio selection
  $('.reveal-content').on('change', '#monthly input[name=day_of_month_or_week_monthly]', function(e) {
    toggleMonthlyDayOfMonthOrWeek($(this).val());
  });

  // Yearly Rule Section: Toggle Month
  $('.reveal-content').on('click', '#yearly .prev-month:not([disabled]), #yearly .next-month:not([disabled])', function(e) {
    $(this).parents('.month').addClass('hide');
    $('.month.' + $(this).attr('month')).removeClass('hide');
  });
  // Yearly Rule Section: toggling as per radio selection
  $('.reveal-content').on('change', '#yearly input[name=day_of_month_or_week_yearly]', function(e) {
    var target_month = $('#yearly').find('.day_of_month, .day_of_week')
    target_month.toggleClass('hide');
    target_month.find('select, input').attr('disabled', true);
    $('#yearly').find('.' + $(this).val()).find('select, input').attr('disabled', false);
  });
  // Duration or Count Section: Toggling as per radio selection
  $('.reveal-content').on('change', 'input[name=duration_or_count]', function(e) {
    $('#duration, #count').addClass('hide').find('select, input').attr('disabled', true);
    $('#' + $(this).val()).removeClass('hide').find('select, input').attr('disabled', false);
  });
  // Recurrence Rule Section: Display applied rule as per changes in Recurrence Rule Inputs
  $('.reveal-content').on('change', '.recurrence_rule_form select, .recurrence_rule_form input', function(e) {
    var data = $(this).parents('form').serialize();
    console.log(data.replace(/%5B/g, '[').replace(/%5D/g, ']').replace(/&/g, ' , '));

    $.ajax({
      url: '/transaction_purposes/display_recurrence_rule_text',
      data: data,
      success: function(result) {
        $('.rules_text').text(result.msg);
      },
      error: function(result) {
        $('.rules_text').html('Error loading content. Please close popup and retry.');
      }
    });
  });
  // Clone fragment
  $('body').on('click', '.clone-fragment', function(e) {
    var blueprint = $(this).parents('.clonable-fragment');
    var clonedFragment = blueprint.clone();
    clonedFragment.find('input, select').val(null);
    $.each(clonedFragment.find('input, select'), function() {
      var name = $(this).attr('name');
      name = name.replace(/[0-9]/, function(i) { return parseInt(i) + 1 })
      $(this).attr('name', name);
    })
    clonedFragment.find('input:first').focus();
    blueprint.after(clonedFragment);
    $(this).remove();
  });
  // Remove clonable fragment
  $('body').on('click', '.delete-fragment', function(e) {
    if($('.clonable-fragment.' + $(this).data('parent-object')).length == 1) {
      alert('Cannot remove all the ' + $(this).data('entity') + 's');
    } else {
      deleteOrRestore($(this));
    }
  });
  // Delete or restore
  function deleteOrRestore(element) {
    var target = element.parents('.clonable-fragment:first').find('input[name$="[_destroy]"]');
    if(target.val() == 'true') {
      target.val(false)
      element.removeClass('warning').addClass('alert').html('&times;');
      element.parents('.clonable-fragment:first').find('input, select').css({'border-color': '#cacaca', 'background': 'white', 'opacity': 1, 'color': '#0a0a0a'}); // TODO: add note as 'Marked for destruction'
    } else {
      target.val(true)
      element.removeClass('alert').addClass('warning').html('&#x27F3;');
      element.parents('.clonable-fragment:first').find('input, select').css({'border-color': 'red', 'background': 'red', 'opacity': 0.2, 'color': 'white'}); // TODO: add note as 'Marked for destruction'
    }
  }
  // Fetch estimate for transaction purpose
  function getEstimateForTransactionPurpose() {
    $.ajax({
      url: '/transaction_purposes/' + $(this).val() + '/get_estimate',
      success: function(result) {
        $('#transaction_transaction_purpose_id').parents('form').find('input[name="transaction[amount]"]').val(result);
      }
    });
  }
  $('body').on('change', '#transaction_transaction_purpose_id', function(e) {
    getEstimateForTransactionPurpose();
  });
  // Filter Accounts as per eligible payment modes
  function toggleAccountsForPaymentMode(payment_mode_select) {
    var target = payment_mode_select.parents('.grid-container').find('.bank_account_select');
    if (target.find('option:selected').attr('payment_modes') && !target.find('option:selected').attr('payment_modes').match(new RegExp(payment_mode_select.val()))) {
      target.val('')
    }
    target.find('option').addClass('hide');
    target.find('option[payment_modes~="' + payment_mode_select.val() + '"]').removeClass('hide');
  }
  $('.payment_mode_select').each(function(e) {
    toggleAccountsForPaymentMode($(this));
  });
  $('body').on('change', '.payment_mode_select', function(e) {
    toggleAccountsForPaymentMode($(this));
  });
  // Show/hide scroll to top button
  $(document).on('scroll', function(){
    if ($(window).scrollTop() > 100) {
      $('.scroll-to-top').addClass('show');
    } else {
      $('.scroll-to-top').removeClass('show');
    }
  });
  // Scroll to top on click
  function scrollToTop() {
    var element = $('body');
    var offset = element.offset();
    var offsetTop = offset.top;
    $('html, body').animate({scrollTop: offsetTop}, 500, 'linear');
  }
  $('.scroll-to-top').on('click', scrollToTop);
});
function toggleMonthlyDayOfMonthOrWeek(selection) {
  var other_class = selection == 'day_of_month' ? 'day_of_week' : 'day_of_month';
  console.log(selection, other_class)
  $('#monthly .' + selection).removeClass('hide');
  $('#monthly .' + other_class).addClass('hide');
  $('#monthly .day_of_month, #monthly .day_of_week').find('select, input').attr('disabled', true);
  $('#monthly .' + selection).find('select, input').attr('disabled', false);
}