btn_content = ''

toggleButton = ->
  $btn = $('.modal.in button[type=submit]')
  
  if $btn.hasClass 'spinning'
    $btn.html btn_content
    $btn.removeClass 'spinning'
  else
    btn_content = $btn.html()
    $btn.addClass('spinning').html('<i class="fa fa-circle-o-notch fa-spin"></i>')

$(document).on 'page:change', ->
  $('form#new_property, form.edit_property').on 'submit', (e) ->
    p = $('[name="property[ad_package_attributes][package]"]:checked').attr('value')

    if p != 'starter' && $('#property_ad_package_attributes_stripe_token').val() == ''
      e.preventDefault()
      
      # Get payment modal
      $.getScript $('.package-container').data('payment-path') + '?package=' + p


$(document).on 'submit', '#stripe-payment-form', (e) ->
  e.preventDefault()

  $form = $(this)

  return if $form.find('button[type=submit]').hasClass('spinning')

  toggleButton()

  Stripe.card.createToken $form, (status, response) ->
    
    if response.error
      
      $form.find('.alert').text(response.error.message)
      $form.find('button').prop('disabled', false)
      toggleButton()
      return false

    else
    
      token = response.id
      $target = $('#property_ad_package_attributes_stripe_token')
      $target.val(token)

      $target.closest('form').submit()

$(document).on 'hidden.bs.modal', '.ad_package_payment.modal', ->
  $('form#new_property .btn, form.edit_property .btn').prop('disabled', false)