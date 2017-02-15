$.getScript("https://maps.googleapis.com/maps/api/js?key=AIzaSyBCTtS1KnxXuh22lty2vDgBn54QlfhiVKM&callback=initMap", function(){

   alert("Script loaded but not necessarily executed.");

});

function initMap() {
  var uluru = {lat: 1.3521, lng: 103.8198};
  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 12,
    center: uluru
  });

var posit
  var infoWindow = new google.maps.InfoWindow({map: map});
        if (navigator.geolocation) {
          navigator.geolocation.getCurrentPosition(function(position) {
            var pos = {
              lat: position.coords.latitude,
              lng: position.coords.longitude
            };
            infoWindow.setPosition(pos);
            infoWindow.setContent('Location found.');
            map.setCenter(pos);
          }, function() {
            handleLocationError(true, infoWindow, map.getCenter());
          });
        } else {
          handleLocationError(false, infoWindow, map.getCenter());
        }


      function handleLocationError(browserHasGeolocation, infoWindow, pos) {
        infoWindow.setPosition(pos);
        infoWindow.setContent(browserHasGeolocation ?
                              'Error: The Geolocation service failed.' :
                              'Error: Your browser doesn\'t support geolocation.');
      }

  <% @freelancers.each do |freelancer| %>

  var marker = new google.maps.Marker({
    position: {lat: <%=freelancer.latitude%>, lng: <%=freelancer.longitude%>},
    url: '<%= restricted_path(freelancer) %>',
    map: map
  });
  var infowindow = new google.maps.InfoWindow();
  marker.addListener('click', function() {
    console.log('entered')
    infowindow.open(map, this);
    infowindow.setContent('<a href="<%= restricted_path(freelancer) %>">Book</a>')
  });

  <% end %>
}