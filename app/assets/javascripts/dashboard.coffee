$(document).on 'page:change', ->

  $('.toggle-change-payment-method').on 'click', (e)->
    console.log 'runnin'
    e.preventDefault()
    $('#current-method-info-wrap, #add-new-method-wrap').toggleClass('hidden')

    # Create an instance of Elements.
    elements = stripe.elements()
    # Custom styling can be passed to options when creating an Element.
    # (Note that this demo uses a wider set of styles than the guide below.)
    style =
      base:
        color: '#32325d'
        fontFamily: '"Helvetica Neue", Helvetica, sans-serif'
        fontSmoothing: 'antialiased'
        fontSize: '16px'
        '::placeholder': color: '#aab7c4'
      invalid:
        color: '#fa755a'
        iconColor: '#fa755a'
    # Create an instance of the card Element.
    card = elements.create('card', style: style)
    # Add an instance of the card Element into the `card-element` <div>.
    # Submit the form with the token ID.

    stripeTokenHandler = (token) ->
      # Insert the token ID into the form so it gets submitted to the server
      form = document.getElementById('payment-form')
      hiddenInput = document.createElement('input')
      hiddenInput.setAttribute 'type', 'hidden'
      hiddenInput.setAttribute 'name', 'stripe_token'
      hiddenInput.setAttribute 'value', token.id
      form.appendChild hiddenInput
      # Submit the form
      form.submit()

    card.mount '#card-element'
    # Handle real-time validation errors from the card Element.
    card.on 'change', (event) ->
      displayError = document.getElementById('card-errors')
      if event.error
        displayError.textContent = event.error.message
      else
        displayError.textContent = ''

    # Handle form submission.
    form = document.getElementById('payment-form')
    form.addEventListener 'submit', (event) ->
      $(form).find('button[type=submit]').attr('disabled', true)
      event.preventDefault()
      stripe.createToken(card).then (result) ->
        $(form).find('button[type=submit]').attr('disabled', false)
        if result.error
          # Inform the user if there was an error.
          errorElement = document.getElementById('card-errors')
          errorElement.textContent = result.error.message
        else
          # Send the token to your server.
          stripeTokenHandler result.token
