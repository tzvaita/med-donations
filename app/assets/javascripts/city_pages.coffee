$(document).on 'page:change', ->

  if window.innerWidth < 760
    $('#entry_text .content').readmore
      collapsedHeight: 60
      moreLink: "<a href='#'>"+$('#entry_text .content').data('more-text')+"</a>"
      lessLink: "<a href='#'>"+$('#entry_text .content').data('less-text')+"</a>"
      speed: 500
      beforeToggle: (trigger, element, expanded) ->
        element.addClass 'transitioning'
      afterToggle: (trigger, element, expanded) ->
        element.removeClass 'transitioning'
