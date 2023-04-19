$(document).on 'click', '#user_contact_details_modal a', ->
  triggerContactLandlordBtn()

$(document).on 'click', '#user_contact_details_modal .close', ->
  triggerContactLandlordBtn()

$(document).on 'hidden.bs.modal', '#user_contact_details_modal', ->
  triggerContactLandlordBtn()

$(document).on 'show.bs.modal', '#new_subscription_modal', ->
  initializeStripe()

window.triggerContactLandlordBtn = ->
  if $('.contact-landlord.btn').length > 0
    $('.contact-landlord.btn').get(0).click()
  else
    Turbolinks.visit()

window.initializeStripe = ->

  return if !$('#payment-button').length

  base_styles =
    color: '#0F100F'

  elements = stripe.elements()

  # In the split test variant, we display 1 card-element instead of multiple fields
  if $('#card').length
    card_number_field = elements.create('card', style: base: base_styles)
    card_number_field.mount '#card'
  else
    card_number_field = elements.create('cardNumber', style: base: base_styles)
    card_expiration_field = elements.create('cardExpiry')
    card_cvc_field = elements.create('cardCvc')

    card_number_field.mount '#card_number'
    card_expiration_field.mount '#card_expiration'
    card_cvc_field.mount '#card_cvc'

  card_button = document.getElementById('payment-button')

  $alert = $('.modal-content .alert')

  card_button.addEventListener 'click', (ev) ->

    # Abort if Stripe has already identified issues/not filled fields, as we then dont want to create payment intent
    if $('.stripe-element-wrapper').is(':visible') && $('.StripeElement--empty, .StripeElement--invalid').length > 0
      $alert.text card_button.dataset.invalidOrEmptyCardError
      return

    # Validate email
    email = $('#email').val() or ''
    name = $('#name-row').val() or ''
    $('.payment-form button').attr 'disabled', true
    $alert.text ''

    # Create subscription(and user if not signed in)
    Rails.ajax
      url: card_button.dataset.createPath
      type: 'post'
      data: [['name', name].join('='), ['email', email].join('='), ['accepts_terms', $('#subscription_terms_of_service').is(':checked')].join('='), ['is_payment_attempt', !$('.payment-form .amount-payable').hasClass('hidden')].join('=')].join('&')
      error: onAjaxError
      success: (data) ->
        if data.success
          if data.modal_html
            $('#new_subscription_modal').replaceWith(data.modal_html);
            $('#new_subscription_modal').modal('show')
          
          window.dataLayer.push 'event': 'complete_registration'

          # Remove email-field as the user has been created
          # If this request just creates a user
          $('#email-row').hide()

          if $('.payment-form .amount-payable').hasClass('hidden')
            $('.payment-form .form-row.expanding, .payment-form .amount-payable, .modal-subtitle, .fineprint .name-row').removeClass('hidden')
            $('.payment-form button').removeAttr 'disabled'
            return

          submitPayment data.payment_intent_secret, email

        else
          $alert.html data.errors.join('<br>')
          $('.payment-form button').removeAttr 'disabled'

    window.dataLayer.push 'event': 'add_payment_info'

  # Handle the payment with Stripe SDK and POST to subscriptions#activate if success
  submitPayment = (client_secret, email) ->
    name = $('#name-row').val() or ''
    email = $('#email').val() or email or ''

    stripe.handleCardPayment(client_secret, card_number_field, payment_method_data: billing_details: name: name, email: email).then (result) ->
      console.log result

      if result.error
        $alert.html result.error.message + '<br><br><i>' + card_button.dataset.cardDeclinedInstructions + '</i>'
        $('.payment-form button').removeAttr 'disabled'

      else
        Rails.ajax
          url: card_button.dataset.activatePath
          type: 'post'
          error: ->
            # Our best option here is to just reload the page, because the subscription has likely been activated by webhook
            # and we dont want to risk the user signing up one more time.
            Turbolinks.visit()
          success: (data) ->
            if data.success
              if data.subscription_status == 'active'
                # Track conversion
                window.dataLayer.push
                  'event': 'premium_signup'
                  'currency': 'SEK'
                  'price': 9

            # Close modal and show user contact details or redirect
            if data.modal_markup
              $('.modal.in').modal('hide')
              $('.modal, .modal-backdrop').remove()
              $('body').append(data.modal_markup)
              $('#user_contact_details_modal').modal('show')
            else
              Turbolinks.visit()


  onAjaxError = (data) ->
    $alert.text 'Something went wrong! Please make sure you are connected to the internet and try again'
    $('.payment-form button').removeAttr 'disabled'
