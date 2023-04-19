$(document).on 'page:change', ->

  $('form.new_tenant_profile').on 'submit', (e) ->
    if $('input#tenant_profile_image_ids').val() == ''
      confirm($(this).find('input[type=submit]').data('no-images-warning'))

  $('select[multiple]').selectize(plugins: ['remove_button'])

  $('.dob-datepicker').datepicker
    dateFormat: 'yy-mm-dd'
    changeMonth: true
    changeYear: true
    yearRange: '-100y:c'
    $('.ui-datepicker').addClass('notranslate')

  $ ->
    flatpickr('.datepicker')
