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
    $('#weekly, #monthly, #yearly').hide();
    $('#weekly, #monthly, #yearly').find('select, input').attr({readonly: true, disabled: true});
    $('#' + $(this).val().toLowerCase()).removeClass('hide').show();
    $('#' + $(this).val().toLowerCase()).find('select, input').attr({readonly: false, disabled: false});
    if($(this).val().toLowerCase() == 'daily') {
      var intervalUnit = 'day(s)';
    } else {
      var intervalUnit = $(this).val().toLowerCase().replace(/ly$/, '(s)');
    }
    $('#interval-unit').text(intervalUnit);
  });
  // Monthly Rule Section: toggling as per radio selection
  $('.reveal-content').on('change', 'input[name=day_of_month_or_week]', function(e) {
    $('#day_of_month, #day_of_week').toggleClass('hide');
  });
  // Weekly Rule Section: Selection of Day of week
  $('.reveal-content').on('click', '#weekly label', function(e) {
    $(this).toggleClass('selected');
    var option = $('#weekly select').find('option[value=' + $(this).attr('for') + ']');
    option.attr('selected', !option.attr('selected'));
  });
  // Monthly Rule Section: Selection of Day of month
  $('.reveal-content').on('click', '#monthly #day_of_month .day', function(e) {
    console.log('-------------')
    $(this).toggleClass('selected');
    var option = $('#monthly #day_of_month select').find('option[value=' + $(this).attr('for') + ']');
    option.attr('selected', !option.attr('selected'));
  });
  // Monthly Rule Section: Selection of Day of week
  $('.reveal-content').on('click', '#monthly #day_of_week .day', function(e) {
    console.log('-------------')
    $(this).toggleClass('selected');
    var option = $('#monthly #day_of_week select').find('option[value=' + $(this).attr('for') + ']');
    option.attr('selected', !option.attr('selected'));
  });
  // Recurrence Rule Section: Display applied rule as per changes in Recurrence Rule Inouts
  $('.reveal-content').on('change', '.recurrence_rule_form select, .recurrence_rule_form input[type="number"]', function(e) {
    console.log('==========================')
    $.ajax({
      url: '/transaction_purposes/display_recurrence_rule_text',
      data: {
        type: $('#transaction_purpose_recurrence_rule_attributes_type').val(),
        interval: $('#transaction_purpose_recurrence_rule_attributes_interval').val(),
        rules: {}
      },
      success: function(result) {
        $('.rules_text').html(result);
      },
      error: function(result) {
        $('.reveal-content').html('Error loading content. Please close popup and retry.');
      }
    });
  });
});
