$(document).on 'page:change', ->
  $('.switch input[type=checkbox]').change ->
    Turbolinks.visit $(this).data('link')

  $('.form-control').change ->
    if $('#search_agent_email').val() != '' && $('#search_agent_first_name').val() != '' && $('#gmaps-input-searchagent').val() != '' && $('#search_agent_rooms').val() != '' && $('#search_agent_max_rent').val() != '' && $('#search_agent_area').val() != '' && $('#search_agent_radius').val() != ''
      $.ajax(
        method: 'GET'
        url: $('.recommendation').data('endpoint')
        data: {
          email: $('#search_agent_email').val(),
          first_name: $('#search_agent_first_name').val(),
          location: $('#gmaps-input-searchagent').val(),
          rooms: $('#search_agent_rooms').val(),
          area: $('#search_agent_area').val(),
          radius: $('#search_agent_radius').val(),
          max_rent: $('#search_agent_max_rent').autoNumeric('get')
        },
      ).success (d) ->
        if d['average_properties'] > 0
          $('.criteria-text').html(d['criteria_text'])
          $('.recommendation').html(d['recommendation_text'])
        else
          emptyText()
    else
      emptyText()

  emptyText = ->
    $('.criteria-text').html('')
    $('.recommendation').html('')
