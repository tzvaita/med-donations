Dropzone.autoDiscover = false

$(document).on 'page:change', ->

  if $('#ui-dropzone').length

    $dropzone = new Dropzone '#ui-dropzone',
      url: $('#ui-dropzone').data('endpoint')
      addRemoveLinks: true
      dictRemoveFile: 'x'
      dictCancelUpload: 'x'

    # Add any existing images to the dropzone
    json = $('#ui-dropzone').data('existing-image-json')
    json.map (img)->
      mockFile = { name: img.filename, size: img.size }
      $dropzone.emit "addedfile", mockFile
      $dropzone.emit "thumbnail", mockFile, img.thumbnail_url
      $dropzone.emit "complete", mockFile

    # On upload success, add image data to data-exiting-image-json
    $dropzone.on 'success', (file, response)->
      console.log 'upload success'
      json = $('#ui-dropzone').data('existing-image-json')
      json.push(response.image_data)
      $('#ui-dropzone').data('existing-image-json', json)

    $dropzone.on 'error', (file, error) ->
      console.log(error)

    $dropzone.on 'removedfile', (file) ->
      json = $('#ui-dropzone').data('existing-image-json')
      new_json = json.filter (i)->
        if file.xhr # In case this is in-current-session uploaded picture
          xhr_resp = JSON.parse(file.xhr.response)
          return xhr_resp.image_data.id != i.id
        else
          return i.id != file.name

      $('#ui-dropzone').data('existing-image-json', new_json)

    # Disable form submitting while upload is going on
    $dropzone.on 'addedfile', ->
      $button = $('#ui-dropzone').closest('form').find('input[type=submit]')
      $button.attr('disabled', true)
      $button.val($button.data('disable-with-during-upload'))

    $dropzone.on 'queuecomplete', ->
      $button = $('#ui-dropzone').closest('form').find('input[type=submit]')
      $button.removeAttr('disabled')
      $button.val($button.data('default-text'))

  # On form submit, grab image ids from data-exiting-image-json and put in listing_images_ids field
  $('form.new_property, form.edit_property, form.new_tenant_profile, form.edit_tenant_profile').on 'submit', (e)->
    # e.preventDefault()
    $form = $(this)

    images_json = $('#ui-dropzone').data('existing-image-json')
    image_ids = images_json.map (i)-> i.id

    $form.find('input[id*="_image_ids"]').val image_ids.join(',')
