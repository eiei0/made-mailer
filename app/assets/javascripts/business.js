// Location address autocomplete
function initAutocomplete() {
  $('.autocomplete').each(function(i, el) {
    var autocomplete = new google.maps.places.Autocomplete(
      this, { types: ['geocode', 'establishment'] }
    );

    // Format selected result that is placed into form
    autocomplete.addListener('place_changed', function() {
      var place = this.getPlace();
      // street_number needs to always be before route because of the way
      // it concatenates the value of the element
      var componentForm = {
        street_number: 'short_name',
        route: 'long_name',
        subpremise: 'long_name',
        locality: 'long_name',
        administrative_area_level_1: 'long_name',
        country: 'long_name',
        postal_code: 'short_name'
      };

      for (var i = 0; i < place.address_components.length; i++) {
        var addressType = place.address_components[i].types[0];
        if (componentForm[addressType]) {
          var val = place.address_components[i][componentForm[addressType]];

          if (addressType === "street_number" || addressType === "route") {
            var streetAddressId = "street_number"
            if (addressType === "street_number") {
              var val = val += " "
            }
            document.getElementById(streetAddressId).value += val;
          } else {
            document.getElementById(addressType).value = val;
          };
        };
      };

      document.getElementById("autocomplete").value = place.name
      document.getElementById("phone").value = place.international_phone_number
      document.getElementById("url").value = place.website
    });
  });

  // Disable return key from submitting form when selecting autocomplete result
  $(document).on('keypress', '.autocomplete', function(e) {
    var code = (e.keyCode ? e.keyCode : e.which);
    if (code == 13) {
      e.preventDefault();
      return false;
    }
  });
};
