// Business search bar
$(function(){
  // Disable return/enter key on this form
  $(document).on('keypress', '#business-search', function(e) {
    if(e.which == 13){
      event.preventDefault();
      return false;
    };
  });

  $(document).on('input', '#business-search', function () {
    // Define delay
    var delay = (function(){
      var timer = 0;
      return function(callback, ms){
        clearTimeout (timer);
        timer = setTimeout(callback, ms);
      };
    })();

    // Trigger search controller action
    delay(function(){
      var form = $("#business-search").parents('form');
      $.get(form.attr('action'), form.serialize(), null, "script");
      return false
    }, 400 );
  });
});
