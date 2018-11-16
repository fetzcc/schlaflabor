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


# The latitude and longitude of your business / place
position = [48.2241196,14.1010463]

showGoogleMaps = () ->

  latLng = new google.maps.LatLng(position[0], position[1])

  mapOptions =
    zoom: 17
    streetViewControl: false
    scaleControl: true
    scrollwheel: false
    navigationControl: false
    mapTypeControl: false
    draggable: true
    mapTypeId: google.maps.MapTypeId.ROADMAP
    center: latLng
    #disableDefaultUI: true

  map = new google.maps.Map(document.getElementById('map'), mapOptions)
  map1 = new google.maps.Map(document.getElementById('map1'), mapOptions)

  console.log map.length
  # Show the default red marker at the location
  marker = new google.maps.Marker
    position: latLng
    map: map
    draggable: false
    animation: google.maps.Animation.DROP
    icon: 'img/marker.png'

if typeof google != 'undefined'
  google.maps.event.addDomListener(window, 'load', showGoogleMaps)
