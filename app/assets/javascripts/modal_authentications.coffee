$(document).on 'click', '#new-autentication-modal .other-option a', (e)->
  e.preventDefault()
  $('#new-autentication-modal #login-content, #new-autentication-modal #signup-content').toggleClass('hidden')
