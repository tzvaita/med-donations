window.initializeFavorites = ->
  return unless window.favoritePropertyIds
  window.favoritePropertyIds.forEach (id)->
    $('button.favorite[data-property-id='+id+']').addClass('active')

$(document).on 'click', 'button.favorite', ->
  $btn = $(this)
  $btn.toggleClass('active')

  Rails.ajax
    url: $btn.data('toggle-path')
    type: 'post'
    error: ->
      $btn.toggleClass('active')
    success: (data) ->
      if data.is_favorite
        window.favoritePropertyIds.push(data.property_id)
      else
        window.favoritePropertyIds = window.favoritePropertyIds.filter (val) -> val != data.property_id

$(document).on 'page:change', ->
  initializeFavorites()
