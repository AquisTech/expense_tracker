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
//= require jquery_ujs
//= require foundation
//= require_tree .

$(document).on('turbolinks:load', function() {
  // Initialize Zurb Foundation JS
  $(document).foundation();
  // Remote modal with AJAX and Reveal
  $('body').on('click', '[data-open="ajax-reveal"]', function(e) {
    e.preventDefault();
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
  $('.reveal-content').on('change', 'select#transaction_purpose_recurrence_rule_attributes_type', function(e) {
    $('#weekly, #monthly, #yearly').addClass('hide');
    $('#weekly, #monthly, #yearly').find('select, input').prop('disabled', true);
    $('#' + $(this).val().toLowerCase()).removeClass('hide');
    if($(this).val().toLowerCase() == 'yearly') {
      $('.month.1').removeClass('hide');
      $('#yearly input[name*=day_of_month_or_week_]:checked').each(function(e) {
        var target_month = $(this).parents('.month');
        target_month.find('input[type=radio]').attr('disabled', false);
        target_month.find('.' + $(this).val()).find('select, input').attr('disabled', false);
      });
    } else {
      $('#' + $(this).val().toLowerCase()).find('select, input').attr('disabled', false);
    }
    if($(this).val().toLowerCase() == 'daily') {
      var intervalUnit = 'day(s)';
    } else {
      var intervalUnit = $(this).val().toLowerCase().replace(/ly$/, '(s)');
    }
    $('#interval-unit').text(intervalUnit);
  });
  // Weekly Rule Section: Selection of Day of week
  $('.reveal-content').on('click', '#weekly label', function(e) {
    $(this).toggleClass('selected');
    var option = $('#weekly select').find('option[value=' + $(this).attr('for') + ']');
    option.attr('selected', !option.attr('selected'));
    $('#weekly select').change();
  });
  // Monthly Rule Section: toggling as per radio selection
  $('.reveal-content').on('change', '#monthly input[name=day_of_month_or_week]', function(e) {
    $('#monthly .day_of_month, #monthly .day_of_week').toggleClass('hide');
    $('#monthly .day_of_month, #monthly .day_of_week').find('select, input').attr('disabled', true);
    $('#monthly .' + $(this).val()).find('select, input').attr('disabled', false);
  });
  // Monthly Rule Section: Selection of Day of month
  $('.reveal-content').on('click', '#monthly .day_of_month .day', function(e) {
    $(this).toggleClass('selected');
    var option = $('#monthly .day_of_month select').find('option[value=' + $(this).attr('for') + ']');
    option.attr('selected', !option.attr('selected'));
    $('#monthly .day_of_month select').change();
  });
  // Monthly Rule Section: Selection of Day of week
  $('.reveal-content').on('click', '#monthly .day_of_week .day', function(e) {
    $(this).toggleClass('selected');
    var target_select_list = $('#monthly .day_of_week select#transaction_purpose_recurrence_rule_attributes_rules_' + $(this).attr('for'));
    var option = target_select_list.find('option[value=' + $(this).attr('week') + ']');
    option.attr('selected', !option.attr('selected'));
    target_select_list.change();
  });
  // Yearly Rule Section: Toggle Month
  $('.reveal-content').on('click', '#yearly .prev-month:not([disabled]), #yearly .next-month:not([disabled])', function(e) {
    $(this).parents('.month').addClass('hide');
    $('.month.' + $(this).attr('month')).removeClass('hide');
  });
  // Yearly Rule Section: toggling as per radio selection
  $('.reveal-content').on('change', '#yearly input[name*=day_of_month_or_week_]', function(e) {
    var target_month = $(this).parents('.month').find('.day_of_month, .day_of_week')
    target_month.toggleClass('hide');
    target_month.find('select, input').attr('disabled', true);
    $(this).parents('.month').find('.' + $(this).val()).find('select, input').attr('disabled', false);
  });
  // Yearly Rule Section: Selection of Day of month
  $('.reveal-content').on('click', '#yearly .day_of_month .day', function(e) {
    $(this).toggleClass('selected');
    var target_select_list = $('#yearly .day_of_month select#transaction_purpose_recurrence_rule_attributes_rules_' + $(this).attr('month'))
    var option = target_select_list.find('option[value=' + $(this).attr('for') + ']');
    option.attr('selected', !option.attr('selected'));
    target_select_list.change();
  });
  // Yearly Rule Section: Selection of Day of week
  $('.reveal-content').on('click', '#yearly .day_of_week .day', function(e) {
    $(this).toggleClass('selected');
    var target_select_list = $('#yearly .day_of_week select#transaction_purpose_recurrence_rule_attributes_rules_' + $(this).attr('month') + '][' + $(this).attr('for'));
    var option = target_select_list.find('option[value=' + $(this).attr('week') + ']');
    option.attr('selected', !option.attr('selected'));
    target_select_list.change();
  });
  // Duration or Count Section: Toggling as per radio selection
  $('.reveal-content').on('change', 'input[name=duration_or_count]', function(e) {
    $('#duration, #count').toggleClass('hide');
    $('#duration, #count').find('select, input').attr('disabled', true);
    $('#' + $(this).val()).find('select, input').attr('disabled', false);
  });
  // Recurrence Rule Section: Display applied rule as per changes in Recurrence Rule Inouts
  $('.reveal-content').on('change', '.recurrence_rule_form select, .recurrence_rule_form input', function(e) {
    var data = $(this).parents('form').serialize();
    console.log(data)
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
});
