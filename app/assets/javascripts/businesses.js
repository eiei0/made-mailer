$(function(){
  $(document).on('keypress', '#business-search', function(e) {
    if(e.which == 13){
      event.preventDefault();
      return false;
    };
  });

  $(document).on('keyup', '#business-search', function () {
    var form = $("#business-search").parents('form');
    $.get(form.attr('action'), form.serialize(), null, "script");
    return false
  });
});
