toggleButton = ->
  $btn = $('form#new_abuse [type="submit"]')

  if $btn.hasClass 'spinning'
    $btn.html btn_content
    $btn.removeClass 'spinning'
    $btn.html($btn.data('content'))
  else
    btn_content = $btn.html()
    $btn.attr('data-content', $btn.html())
    $btn.addClass('spinning').html('<i class="fa fa-circle-o-notch fa-spin"></i>')

$(document).on 'submit', 'form#new_abuse', (e) ->
  e.preventDefault()

  $form = $(this)

  return if $form.find('[type="submit"]').hasClass('spinning')

  toggleButton()
