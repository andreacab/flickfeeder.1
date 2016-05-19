var ready;
ready = function() {
  if ($('.events.new').length > 0){
    $('#event_name').on("change keyup", function(){
      if ($('#event_name').val().length > 0){
        $('.event-dates').fadeIn(700);
      } else {
        $('.event-dates').fadeOut();
      }
    });
  }
};

$(document).ready(ready);
$(document).on('page:change', ready);
