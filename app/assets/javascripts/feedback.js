$(document).on('click', '#trustpilot-review a, #trustpilot-review .close', () => Turbolinks.visit());

$(document).on('hidden.bs.modal', '#trustpilot-review', () => Turbolinks.visit());

$(document).on('click', '#found-home .btn, #cancel-modal-3 .btn', () => triggerNextModal());

window.triggerNextModal = function() {
  $(this).on('ajax:success', function(event) {
    const data = event.detail[0];
    if (data.modal_markup) {
      $('.modal.in').modal('hide');
      $('.modal, .modal-backdrop').remove();

      $('body').append(data.modal_markup);

      if (data.modal_id) {
        $('#' + data.modal_id).modal('show');
      } else if (data.success === false && !data.modal_id) {
        $('#cancel-modal-3').modal('show');
      } else {
        $('.cancel-subscription-btn').replaceWith(data.sub_btn)
        $('#found-home').modal('show');
      }

      $('#feedback_rating').barrating({theme: 'fontawesome-stars'});
    }
  })
  $(this).on('ajax:error', function (event) {
    // error
  });
};
