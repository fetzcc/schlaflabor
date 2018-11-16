var maps, showGoogleMaps;

$(function() {
  var api, formTimeout;
  $(document).ready(function() {
    if (window.location.hash) {
      return $.smoothScroll({
        scrollTarget: window.location.hash + "",
        offset: -150
      });
    }
  });
  $('body').smoothScroll({
    delegateSelector: '[data-scroll]',
    offset: -150,
    speed: 1000
  });
  $(window).resize(function() {
    if ($(window).outerWidth() < 992) {
      return $.smoothScroll('options', {
        offset: -80
      });
    } else {
      return $.smoothScroll('options', {
        offset: -150
      });
    }
  });
  $(window).trigger('resize');
  $("#mmenu").mmenu({
    "extensions": ["pagedim-black", "position-right", "fx-menu-slide", "fx-listitems-slide"],
    "navbars": [
      {
        "position": "top",
        "content": ["<a class='nav-logo d-flex align-items-center justify-content-center' href='/'><img src='img/logo.png' srcset='img/logo.png 1x, img/logo@2x.png 2x' alt='Othmar Fetz'></a>"]
      }
    ],
    "onClick": {
      "close": true
    }
  });
  api = $("#mmenu").data("mmenu");
  $('.hamburger').on("click", function() {
    api.open();
    return api.close();
  });
  $("#header").headroom({
    "offset": 50,
    "tolerance": 10,
    "classes": {
      "initial": "animated",
      "pinned": "slideDown",
      "unpinned": "slideUp"
    },
    onTop: function() {
      return $('#header .hotline-btn').addClass('btn-outline-primary').removeClass('btn-primary');
    },
    onNotTop: function() {
      return $('#header .hotline-btn').addClass('btn-primary').removeClass('btn-outline-primary');
    }
  });
  formTimeout = null;
  if ($('.contact-form').length > 0) {
    $('.contact-form').each(function(i, e) {
      var $target, $this;
      $this = $(e);
      $target = $this.find('.contactTarget');
      $this.ajaxForm({
        beforeSubmit: function() {
          return $this.find('.form-control, .btn').prop('disabled', function() {
            return !$(this).prop('disabled');
          });
        },
        success: function(responseText, statusText, xhr, $form) {
          $this.find('.form-control, .btn').prop('disabled', function() {
            return !$(this).prop('disabled');
          });
          $this.find('.subbtn').prop('disabled', true);
          $target.html('<p class="text-success lead">E-Mail erfolgreich versendet</p>').addClass('show');
          return formTimeout = setTimeout(function() {
            $this.find('.subbtn').prop('disabled', false);
            return $target.removeClass('show');
          }, 5000);
        },
        error: function(responseText, statusText, xhr, $form) {
          $this.find('.form-control, .btn').prop('disabled', function() {
            return !$(this).prop('disabled');
          });
          $this.find('.subbtn').prop('disabled', true);
          $target.html('<p class="text-danger">E-Mail nicht gesendet<br><small>' + responseText.responseText + '</small></p>').addClass('show');
          return formTimeout = setTimeout(function() {
            $this.find('.subbtn').prop('disabled', false);
            return $target.removeClass('show');
          }, 5000);
        },
        url: 'core/contact.php',
        type: 'post',
        clearForm: true,
        resetForm: true
      });
      return $target.on('click', function(e) {
        e.preventDefault();
        clearTimeout(formTimeout);
        $(this).removeClass('show');
        return $this.find('.subbtn').prop('disabled', false);
      });
    });
  }
  return $('#openModal').on('hidden.bs.modal', function(e) {
    $('#openModal .contact-form').resetForm();
    $('#openModal .contact-form').clearForm();
    $('#openModal .contactTarget').html('').removeClass('show');
    return $('#openModal .subbtn').prop('disabled', false);
  });
});

// define array of maps. marker and center for different values
maps = [
  {
    marker: [48.2241196,
  14.1010463],
    center: [48.2245196,
  14.1019463],
    map_id: "map_1"
  },
  {
    marker: [48.2241196,
  14.1010463],
    center: [48.2235196,
  14.1005463],
    map_id: "map_2"
  }
];

showGoogleMaps = function() {
  var centerPoint, j, len, m, map, mapOptions, marker, markerPoint, results;
  // define maps options with hidden all map controls
  mapOptions = {
    zoom: 17,
    draggable: true,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    disableDefaultUI: true
  };
  results = [];
  for (j = 0, len = maps.length; j < len; j++) {
    m = maps[j];
    // set center and marker point if there are different
    centerPoint = new google.maps.LatLng(m.center[0], m.center[1]);
    markerPoint = new google.maps.LatLng(m.marker[0], m.marker[1]);
    // init map
    map = new google.maps.Map(document.getElementById(m.map_id), mapOptions);
    map.setCenter(centerPoint);
    // draw marker on map
    results.push(marker = new google.maps.Marker({
      position: markerPoint,
      map: map,
      draggable: false,
      animation: google.maps.Animation.DROP,
      icon: 'img/marker.png'
    }));
  }
  return results;
};

if (typeof google !== 'undefined') {
  google.maps.event.addDomListener(window, 'load', showGoogleMaps);
}

//# sourceMappingURL=core.js.map
