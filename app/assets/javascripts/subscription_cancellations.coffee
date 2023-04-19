$(document).on 'click', '.open-another-modal', (e)->
  e.preventDefault()

  $this_modal = $(this).closest('.modal')
  $target = $($(this).data('target'))

  $this_modal.on 'hidden.bs.modal', ->
    $target.modal('show')
    $this_modal.unbind('hidden.bs.modal')


  $this_modal.modal('hide')
