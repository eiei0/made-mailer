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
