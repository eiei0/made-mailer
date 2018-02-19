function initAutocomplete() {
  $('.autocomplete').each(function(i, el) {
    var autocomplete = new google.maps.places.Autocomplete(
      this, { types: ['geocode', 'establishment'] }
    );

    autocomplete.addListener('place_changed', function() {
      var place = this.getPlace();
      var fields = ["street_number", "subpremise", "phone", "url"];

      for (var i = 0; i < fields.length; i++) {
        window[fields[i]] = document.getElementById(fields[i]).value;
      };

      var componentForm = {
        street_number: 'short_name',
        route: 'long_name',
        subpremise: 'long_name',
        locality: 'long_name',
        administrative_area_level_1: 'long_name',
        country: 'long_name',
        postal_code: 'short_name'
      };

      var fullAddress = [];
      for (var i = 0; i < place.address_components.length; i++) {
        var addressType = place.address_components[i].types[0];
        if (addressType === "street_number" || addressType === "route") {
          if (addressType === "street_number") {
            var val = place.address_components[i][componentForm[addressType]];
            fullAddress[0] = val;
          } else if (addressType === "route") {
            var val = place.address_components[i][componentForm[addressType]];
            fullAddress[1] = val;
          };
        } else if(componentForm[addressType]) {
          var val = place.address_components[i][componentForm[addressType]];
          document.getElementById(addressType).value = val;
        };
      };

      document.getElementById('street_number').value = fullAddress.join(" ");
      document.getElementById("autocomplete").value = place.name
      document.getElementById("phone").value = place.formatted_phone_number
      document.getElementById("url").value = place.website

      for (var i = 0; i < fields.length; i++) {
        if (eval(fields[i]) == document.getElementById(fields[i]).value) {
          document.getElementById(fields[i]).value = ""
        }
      };
    });
  });

  // Disable return key
  $(document).on('keypress', '.autocomplete', function(e) {
    var code = (e.keyCode ? e.keyCode : e.which);
    if (code == 13) {
      e.preventDefault();
      return false;
    }
  });
};
