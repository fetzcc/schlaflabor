$ ->

  $(document).ready () ->
    if window.location.hash
      $.smoothScroll
        scrollTarget: window.location.hash + ""
        offset: -150

  $('body').smoothScroll
    delegateSelector: '[data-scroll]'
    offset: -150
    speed: 1000
    
  $(window).resize () ->
    if $(window).outerWidth() < 992
      $.smoothScroll 'options', {offset: -80}
    else
      $.smoothScroll 'options', {offset: -150}
      
  $(window).trigger('resize')

  $("#mmenu").mmenu
    "extensions": [
      "pagedim-black",
      "position-right",
      "fx-menu-slide",
      "fx-listitems-slide"
    ]
    "navbars": [
      {
         "position": "top"
         "content": [
            "<a class='nav-logo d-flex align-items-center justify-content-center' href='/'><img src='img/logo.png' srcset='img/logo.png 1x, img/logo@2x.png 2x' alt='Othmar Fetz'></a>"
         ]
      }
    ]
    "onClick": 
      "close": true

  api = $("#mmenu").data("mmenu")

  $('.hamburger').on "click", () ->
    api.open()
    api.close()

  $("#header").headroom
    "offset": 50
    "tolerance": 10
    "classes": 
      "initial": "animated"
      "pinned": "slideDown"
      "unpinned": "slideUp"
    onTop: () ->
      $('#header .hotline-btn').addClass('btn-outline-primary').removeClass('btn-primary')
    onNotTop: () ->
      $('#header .hotline-btn').addClass('btn-primary').removeClass('btn-outline-primary')

  formTimeout = null

  if $('.contact-form').length > 0
    $('.contact-form').each (i, e) ->
      $this = $(e)
      $target = $this.find('.contactTarget')

      $this.ajaxForm
        beforeSubmit: () ->
          $this.find('.form-control, .btn').prop 'disabled', () ->
            return !$(this).prop('disabled')
        success: (responseText, statusText, xhr, $form) ->
          $this.find('.form-control, .btn').prop 'disabled', () ->
            return !$(this).prop('disabled')
          $this.find('.subbtn').prop('disabled', true)
          $target.html('<p class="text-success lead">E-Mail erfolgreich versendet</p>').addClass('show')
          formTimeout = setTimeout () ->
            $this.find('.subbtn').prop('disabled', false)
            $target.removeClass('show')
          , 5000
        error: (responseText, statusText, xhr, $form) ->
          $this.find('.form-control, .btn').prop 'disabled', () ->
            return !$(this).prop('disabled')
          $this.find('.subbtn').prop('disabled', true)
          $target.html('<p class="text-danger">E-Mail nicht gesendet<br><small>' + responseText.responseText + '</small></p>').addClass('show')
          formTimeout = setTimeout () ->
            $this.find('.subbtn').prop('disabled', false)
            $target.removeClass('show')
          , 5000
        url: 'core/contact.php'
        type: 'post'
        clearForm: true
        resetForm: true

      $target.on 'click', (e) ->
        e.preventDefault()
        clearTimeout(formTimeout)
        $(this).removeClass('show')
        $this.find('.subbtn').prop('disabled', false)
  
  $('#openModal').on 'hidden.bs.modal', (e) ->
    $('#openModal .contact-form').resetForm()
    $('#openModal .contact-form').clearForm()
    $('#openModal .contactTarget').html('').removeClass('show')
    $('#openModal .subbtn').prop('disabled', false)


# define array of maps. marker and center for different values
maps = [
  {
    marker: [47.171420, 13.098130]
    center: [47.171420, 13.098130]
    map_id: "map_1"
  }
  {
    marker: [47.321830, 13.153550]
    center: [47.321830, 13.153550]
    map_id: "map_2"
  }
]

showGoogleMaps = () ->
  # define maps options with hidden all map controls
  mapOptions =
    zoom: 17
    draggable: true
    mapTypeId: google.maps.MapTypeId.ROADMAP
    disableDefaultUI: true

  for m in maps
    # set center and marker point if there are different
    centerPoint = new google.maps.LatLng(m.center[0], m.center[1])
    markerPoint = new google.maps.LatLng(m.marker[0], m.marker[1])
    # init map
    map = new google.maps.Map(document.getElementById(m.map_id), mapOptions)
    map.setCenter(centerPoint)
    # draw marker on map
    marker = new google.maps.Marker
      position: markerPoint
      map: map
      draggable: false
      animation: google.maps.Animation.DROP
      icon: 'img/marker.png'

if typeof google != 'undefined'
  google.maps.event.addDomListener(window, 'load', showGoogleMaps)
