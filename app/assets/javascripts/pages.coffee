$(document).on 'page:change', ->

  # $('header#video').vide
  #   mp4: '/background.mp4'
  window.dataLayer.push
    'event':'virtualPageView',
    'virtualUrl': window.location.href

  $('.what.row button').on 'click', (e) ->
    e.preventDefault()
    $(this).toggleClass 'active'
    $("input.property_type[value='#{$(this).data('value')}']").prop('checked', $(this).hasClass('active'))

  $('input.autonumeric').autoNumeric 'init'

  $('[data-toggle="popover"]').popover()

  $(".cookies-eu-ok").click (e) ->
    e.preventDefault();
    $.cookie('cookie_eu_consented', 'true', {path: '/', expires: 365});
    $('.cookies-eu').remove();

  if(typeof mouseflow != "undefined")
    mouseflow.newPageView(window.location.href)

$(document).on 'submit', 'form', (e) ->
  $(this).find('input.autonumeric').each ->
    $(this).val $(this).autoNumeric 'get'

# $(document).on 'hidden.bs.modal', '.modal', ->
#   $(this).remove()

$(document).on 'shown.bs.modal', '.modal', ->
  if(typeof mouseflow != "undefined")
    mouseflow.newPageView(window.location.href)
