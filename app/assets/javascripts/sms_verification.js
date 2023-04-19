$(document).on('click', '#property-form-submit', function() {
  if (!$(this).data('skip-sms-verification')) {
    event.preventDefault()

    $('.modal.in').modal('hide')

    $('#sms-verification-modal')
      .clone()
      .modal('show')
  }
})

$(document).on('click', '#sms_verification_submit_1', function() {
  $('.in #sms_verification_submit_1').attr('disabled', true)

  $.ajax({
    method: 'POST',
    url: '/sms-verification',
    data: { phone_number: $('.in #sms_verification_phone_number_input').val() },
  }).done(function(r) {
    if (r && r.status == 'ok') {
      $('.in #sms_verification_phone_number_cell')
        .css('position', 'absolute')
        .fadeOut()

      $('.in #sms_verification_code_cell').fadeIn()

      $('.in #sms_verification_submit_1')
        .css('position', 'absolute')
        .fadeOut()

      $('.in #sms_verification_submit_2').fadeIn()
    } else if (r && r.status == 'invalid_phone_number_error') {
      $('.in #sms_verification_submit_1').attr('disabled', false)
      $('.in #sms_verification_invalid_phone_number_error').fadeIn()
    } else if (r && r.status == 'internal_error') {
      $('.in #sms_verification_invalid_phone_number_error')
        .css('position', 'absolute')
        .fadeOut()

      $('.in #sms_verification_internal_error').fadeIn()
    }
  }).fail(function(r) {
    $('.in #sms_verification_submit_1').attr('disabled', false)
  })
})

$(document).on('click', '#sms_verification_submit_2', function() {
  $('.in #sms_verification_submit_2').attr('disabled', true)

  $.ajax({
    method: 'POST',
    url: '/sms-verification/verify',
    data: { code: $('.in #sms_verification_code_input').val() },
  }).done(function(r) {
    if (r && r.status == 'ok') {
      $('.in #sms_verification_skip_button').click()
    } else if (r && r.status == 'incorrect_code') {
      $('.in #sms_verification_submit_2').attr('disabled', false)
      $('.in #sms_verification_incorrect_code_error').fadeIn()
    }
  }).fail(function(r) {
    $('.in #sms_verification_submit_2').attr('disabled', false)
  })
})

$(document).on('click', '#sms_verification_skip_button', function() {
  $('.modal.in').modal('hide')

  $('#property-form-submit')
    .data('skip-sms-verification', true)
    .click()
})
