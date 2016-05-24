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
    // GOOGLE MAPS | START
      var map;
      function initMap() {
        map = new google.maps.Map(document.getElementById('map'), {
          center: {lat: -34.397, lng: 150.644},
          zoom: 8
        });
      }
    // GOOGLE MAPS | END
  }



};

$(document).ready(ready);
$(document).on('page:change', ready);
