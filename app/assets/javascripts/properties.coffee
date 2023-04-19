window.imageLoadFailed = (e)->
  $(e).attr 'src', 'data:image/jpeg;base64,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'

slugify = (str) ->
  str.toString().toLowerCase().replace(/^\s+|\s+$/g, '').replace('ø', 'o').replace('å', 'a').replace(/\s+/g, '-').replace(/-+/g, '-')

window.initializeSwiperJs = () ->
  mySwiper = new Swiper('.swiper-container',
  direction: 'horizontal'
  mousewheel: false
  loop: true
  navigation:
    nextEl: '.swiper-button-next'
    prevEl: '.swiper-button-prev')

$(document).on 'page:change', ->

  if $('.leaflet-map').length
    $('.leaflet-map').each ->
      e = $(this)
      latlng = [e.data('lat'), e.data('lng')]
      map = L.map(e.attr('id'), {})
      map.setView(latlng, 15)
      marker = L.marker(latlng).addTo(map)
      L.tileLayer('https://{s}.tile.osm.org/{z}/{x}/{y}.png',
        attribution: 'Map data &copy; <a href="https://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>'
        maxZoom: 18).addTo map

  $(document).trigger('refresh_autonumeric');

  $('.display-filters-button-container .fb-button').on 'click', ->
    $('.display-filters-button-container').hide()
    $('#search-filters').show()

  $('.hide-filters-button').on 'click', ->
    $('#search-filters').hide()
    $('.display-filters-button-container').show()

  $('a.scroll-to').on 'click', ->
    target = $( $(this).attr('href') )
    $(document).scrollTo(target, 800)

  $('button#load-more').on 'click', ->
    $('#loading-spinner').show()
    $.getScript $('.pagination .next_page').attr('href')
    $('#pagination-load-more').hide()

  $('.order-results-by select#order-by').selectmenu
    change: ->
      window.loadSearchResults(false)
      # $(this).closest('form').find('button[type=submit]').trigger 'click'

  $('.fotorama').fotorama()

  if $('.infinite-pagination').size() > 0
    $(window).on 'scroll', ->
      more_posts_url = $('.infinite-pagination a.next_page').attr('href')
      bottom_distance = 20
      if more_posts_url and $(window).scrollTop() > $(document).height() - $(window).height() - bottom_distance
        $('.infinite-pagination').html '<div class="spinner"><div class="bounce1"></div><div class="bounce2"></div><div class="bounce3"></div></div>'
        $.getScript more_posts_url

  $('.slider').each (i, e)->
    $elem = $(this)
    values = if($elem.data('value') && $elem.data('value').length > 1) then $elem.data('value').split('-') else [$elem.data('min'), $elem.data('max')]
    $(this).slider(
      range: true
      min: $elem.data('min')
      max: $elem.data('max')
      step: (parseInt($elem.data('step')) || 1)
      values: values
      stop: () ->
        window.loadSearchResults()
    ).bind(
      slide: (e, _v) ->
        value = $(e.target).slider('values')
        $parent = $(e.target).parent()
        unit = ($(e.target).data('unit') || '')
        $parent.find('.min-value').html([value[0], unit].join(' '))
        $parent.find('.max-value').html([value[1], unit].join(' '))

        $( $(e.target).data('target') ).val value.join('-')
    )

  $('.sliderSingle').each (i, e)->
    $elem = $(this)
    value = $elem.data('value')
    $(this).slider
      min: $elem.data('min')
      max: $elem.data('max')
      value : value
      stop: () ->
        window.loadSearchResults()
      slide: (e, v) ->
        value = v.value
        $parent = $(e.target).parent()
        newvalue = $parent.find('#radius_label').text().replace(/\d+/,value)
        $parent.find('#radius_label').text(newvalue)
        $( $(e.target).data('target') ).val value
        $('#radius_changed').val true

  $('#properties_carousel').carousel
    interval: 10000

  $("#properties_carousel").on 'slid.bs.carousel', () ->
    initializeSwiperJs()

  # use flatpickr to select date when creating a listing
  $ ->
    flatpickr('.prop-datepicker')

  $('.toggleArea').on 'click', (e) ->
    e.preventDefault()
    $(this).toggleClass('active')
    $( $(this).data('target') ).toggleClass('hidden')
  $('#gmaps-input-address-sideform').on 'change', ->
    $('#gmaps-input-address-sideform').submit()

  $('#property_type, #rental_period, #profile_type').on 'change', ->
    window.loadSearchResults()

  $('.submit-button-container .fb-button').on 'click', ->
    window.loadSearchResults(false);

  window.loadSearchResults = (falseLoadOnMobile = true) ->

    data =
      'location': $('#geolocations').val()
      'rooms': $('#rooms_range').val()
      'area': $('#area_range').val()
      'radius': $('#radius_range').val()
      'property_types': $('select#property_type').val()
      'rental_period': $('select#rental_period').val()
      'profile_type': $('select#profile_type').val()
      'order': $('#order-by').val()

    rent = 0 + '-' + $('#rent_range').val()
    if (rent != window.searchConfig.default_rent_range)
      data['rent'] = rent

    # Delete blank/default values, to make urls prettier
    Object.keys(data).map (k)->
      delete data[k] if !!!data[k]

    if $('body').hasClass('tenant_profiles_index')

      path = window.location.pathname

    else

      # Finding an appropriate URL to use for the query. It may be the url of either a citypage of category `city`, one of category `frontpage`
      # or ultimately, we'll use the properties_path
      if location and $.inArray(slugify(location), window.searchConfig.city_page_slugs) > -1
        path = [ window.searchConfig.properties_path, slugify(location) ].join('/')
        delete data.location
      else if !location and data['property_types']
        path = window.searchConfig[data.property_types+'s_path']
        delete data.property_types
      else
        path = window.searchConfig.properties_path

    url = path
    url += '?' + $.param(data) unless Object.keys(data).length == 0

    # On small screens, we have the filters hidden by default, so a turbolinks reload will ruin the user experience
    # so on small screens, we'll do a dry run only the fetch the number of results this search provides, until the user pushes the button
    # to get the actual results. Thats the explanation of the `falseLoadOnMobile` nonsense
    if window.innerWidth <= 768 && falseLoadOnMobile
      $.get url, (resp) ->
        $('#search-filters .submit-button-container .fb-button span').html $(resp).find('.total-results b').html()
    else
      Turbolinks.visit url

  initializeSwiperJs()
