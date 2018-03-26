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

        if (addressType === "subpremise") {
          toggleSecondAddress();
        }

        if (addressType === "street_number" || addressType === "route") {
          var val = place.address_components[i][componentForm[addressType]];
          if (addressType === "street_number") {
            fullAddress[0] = val;
          } else if (addressType === "route") {
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

$("#toggle-second-address").on("click", function() {
  toggleSecondAddress();
});

function toggleSecondAddress() {
  if ($("#address-two-field").is(":visible") == true) {
    $("#address-two-field").hide("fast");
    $("#toggle-second-address").text("Add second address field?")
  } else {
    $('#address-two-field').show("fast");
    $("#toggle-second-address").text("Remove second address field?")
  }
};

$(".pannel-toggle").on("click", function() {
  togglePanelText();
  togglePanels();
});

$("#business-info-next-btn").on("click", function() {
  togglePanels();
});

$("#mailer-options-toggle").on("change", function() {
  var deliverNow = $("#deliver-now-toggle").find(":input");

  if (deliverNow.is(':checked') === true) {
    deliverNow.prop('checked', false);

    if ($(this).find(":input").is(':checked') === true){
      $('#connection-point').show("fast");
      $('#delivery-date').show("fast");
      $('#business-mailer-options').show("fast");
    } else {
      $('#connection-point').hide("fast");
      $('#delivery-date').hide("fast");
      $('#business-mailer-options').hide("fast");
    }
  } else {
    if ($(this).find(":input").is(':checked') === true){
      $('#connection-point').show("fast");
      $('#delivery-date').show("fast");
      $('#business-mailer-options').show("fast");
    } else {
      $('#connection-point').hide("fast");
      $('#delivery-date').hide("fast");
      $('#business-mailer-options').hide("fast");
    }
  }
});

$(document).ready(function () {
  if ($("#mailer-options-toggle").find(":input").is(':checked') === 'true') {
    $('#connection-point').show("fast");
    $('#delivery-date').show("fast");
  } else {
    $('#connection-point').hide("fast");
    $('#delivery-date').hide("fast");
  }
});

$("#deliver-now-toggle").on("change", function() {
  var mailerOptions = $("#mailer-options-toggle").find(":input");

  if (mailerOptions.is(':checked') === true) {
    mailerOptions.prop('checked', false);

    if ($(this).find(":input").is(':checked') === true){
      $('#connection-point').show("fast");
      $('#delivery-date').hide("fast");
      $('#business-mailer-options').show("fast");
    } else {
      $('#connection-point').hide("fast");
      $('#business-mailer-options').hide("fast");
    }
  } else {
    if ($(this).find(":input").is(':checked') === true){
      $('#connection-point').show("fast");
      $('#business-mailer-options').show("fast");
    } else {
      $('#connection-point').hide("fast");
      $('#business-mailer-options').hide("fast");
    }
  }
});

function togglePanels() {
  if ($('#delivery-options-body').is(":visible") == true){
    $('#business-information-body').show("fast");
    $('#delivery-options-body').hide("fast");
  } else {
    $('#business-information-body').hide("fast");
    $('#delivery-options-body').show("fast");
  }
};

function togglePanelText() {
  if ($("#business-information-body").is(":visible") == true) {
    $('#business-info-header-toggle').text("Show")
    $('#delivery-options-header-toggle').text("Hide")
  } else {
    $('#business-info-header-toggle').text("Hide")
    $('#delivery-options-header-toggle').text("Show")
  };
};
