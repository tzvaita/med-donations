hideMaxRentPopup = ->
  setCookie('max-rent-shown', 1, 1)
  $('.overlay').removeClass('animate')
  $('#max-rent-popup').hide()

  window.dataLayer.push({event: 'max_rent_popup_closed'})

$(document).on 'page:change', ->
  $maxRentSlider = $('#max_rent_slider')
  $maxRentPopup = $('#max-rent-popup')

  maxRentShown = getCookie('max-rent-shown')

  if maxRentShown == '' && $maxRentPopup.length
    $('.overlay').addClass('animate')

    $('.overlay').on 'click', hideMaxRentPopup
    $('#max-rent-popup .close').on 'click', hideMaxRentPopup

    $maxRentPopup.animate({opacity: 1}, 500).css({'visibility': 'visible', 'height': 'auto'});
    window.dataLayer.push({event: 'max_rent_popup_shown'})

    $('#max-rent-popup .max-btn').on 'click', (e)->
      hideMaxRentPopup()
      $maxRentSlider.slider 'values', 1, $(this).data('price')
      $maxRentSlider.trigger 'slide'
      window.dataLayer.push({event: 'max_rent_popup_rent_selected'})

      window.loadSearchResults(false)

    $('#max-rent-popup .no-max-btn').on 'click', (e)->
      hideMaxRentPopup()
      $maxRentSlider.slider 'values', 1, $maxRentSlider.data('max')

      if $maxRentSlider.slider 'values', 1 != $maxRentSlider.data('max')
        window.loadSearchResults(false)
