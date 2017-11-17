// Business search bar
$(function(){
  // Disable return/enter key on this form
  $(document).on('keypress', '#business-search', function(e) {
    if(e.which == 13){
      event.preventDefault();
      return false;
    };
  });

  // Trigger search controller action on keypress
  $(document).on('keyup', '#business-search', function () {
    var form = $("#business-search").parents('form');
    $.get(form.attr('action'), form.serialize(), null, "script");
    return false
  });
});

// Select all checkboxes and add/remove business_ids hidden field
$(document).on('click', '#select-all', function () {
  var arr = $(this).val().split(/[ ,]+/);

  if(this.checked) {
    $(':checkbox').each(function() {
      this.checked = true;
    });
    $('#intro-button, #followup-button').append("<input type='hidden' name='business_ids' id='appended-ids' value='" + arr + "'>");
  } else {
    $(':checkbox').each(function() {
      this.checked = false;
    });
    $('#intro-button, #followup-button').find("#appended-ids").remove()
  }
});

// Create/remove hidden field with business id
$(document).on('click', '#single-checkbox', function () {
  value = $(this).val();
  if(this.checked) {
    $('#intro-button, #followup-button').append("<input type='hidden' name='business_id' id='appended-id-" + value + "' value='" + value +"'>");
  } else {
    $('#intro-button, #followup-button').find("#appended-id-"+ value + "").remove()
  }
});
