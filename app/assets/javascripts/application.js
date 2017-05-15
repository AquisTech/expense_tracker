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
    $('#' + $(this).val().toLowerCase()).removeClass('hide').show();
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

});
