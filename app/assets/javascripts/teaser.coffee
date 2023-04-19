desktopPopupTimeout = null

slideForward = ->
  clearTimeout(desktopPopupTimeout)
  $('.teaser').addClass('hide-under-bottom')
  $('.teaser-2').addClass('show-from-bottom')
  $('.teaser-2').removeClass('hide-under-bottom')

showMobileTeaser = ->
  $('.mobile-teaser').addClass('show-from-top')
  $('.overlay').addClass('animate')

hideMobileTeaser = ->
  $('.overlay').removeClass('animate')
  $('.mobile-teaser').removeClass('show-from-top')
  $('.mobile-teaser').addClass('hide-under-top')

slideBack = ->
  $('.teaser-2').addClass('hide-under-bottom')
  $('.teaser-2').removeClass('show-from-bottom')
  $('.teaser').removeClass('hide-under-bottom')

hideExitTeaser = ->
  $('.overlay').removeClass('animate')
  $('.exit-teaser').animate({opacity: 0}, 500).css('visibility', 'hidden');
  if $('.teaser-2').hasClass('hide-under-bottom')
    $('.teaser-2').removeClass('hide-under-bottom')
    $('.teaser-2').addClass('show-from-bottom')

hideTeaser = ->
  setCookie('popup-hidden', 1, 1/24)
  $('.teaser').addClass('hide-under-bottom')
  false

$(document).on 'page:change', ->

  visited = getCookie('popup-visited')
  hidden = getCookie('popup-hidden')

  desktopPopupTimeout = setTimeout(slideForward, 4000) if visited == ''

  if visited == ''
    $(window).on 'mouseleave', (e) ->
      return if (e.clientY > 20)
      clearTimeout(desktopPopupTimeout)
      $('.exit-teaser').animate({opacity: 1}, 500).css('visibility', 'visible');
      $('.overlay').addClass('animate')
      if $('.teaser-2').hasClass('show-from-bottom')
        $('.teaser-2').removeClass('show-from-bottom')
        $('.teaser-2').addClass('hide-under-bottom')

      $('.overlay').on 'click', hideExitTeaser
      $('.exit-teaser .close').on 'click', hideExitTeaser
      $(window).off 'mouseleave'

  if $(window).width() < 768
    setTimeout(showMobileTeaser, 7000) if visited == ''
    $('.mobile-teaser .teaser-header').on 'click', hideMobileTeaser
    $('.overlay').on 'click', hideMobileTeaser
  else if hidden != '1'
    $('.teaser').show()
    $('.teaser-2 .trigger-hide').on 'click', slideBack
    $('.teaser').on 'click', slideForward
    $('.teaser .close').on 'click', hideTeaser

  setCookie('popup-visited', 1, 365)
