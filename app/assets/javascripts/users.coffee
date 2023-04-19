$(document).on 'page:change', ->

  $('.login.modal .facebook-btn').on 'click', ->
    window.ga 'send', 'event', 'signup', 'facebook btn click'

  $('.user_role input').on 'click', (e) ->
    $('.landlord-fields, .search-agent-fields').toggleClass 'hidden'

  $('.show-signup-form').click (e) ->
    e.preventDefault()

    $(this).closest('.modal').find('.form').removeClass('hidden')
    $(this).hide()

  if $('.auto-opening.login.modal').length
    setTimeout(->
      $('.auto-opening.login.modal').modal
        backdrop: 'static'
        keyboard: false
    , 2500)

  $('.ajax.registration.form').on 'submit', ->
    window.ga 'send', 'event', 'signup', 'email registration submit'