// 'use strict';
//
// function enableEnterKey(input) {
//   var _addEventListener = input.addEventListener ? input.addEventListener : input.attachEvent;
//
//   var addEventListenerWrapper = function addEventListenerWrapper(type, listener) {
//     if (type === 'keydown') {
//       /* Store existing listener function */
//       var _listener = listener;
//       listener = function listener(event) {
//         /* Simulate a “down arrow” keypress if no address has been selected */
//         var s = document.getElementsByClassName('pac-item-selected').length > 0;
//         if (event.which === 13 && !s) {
//           var e = JSON.parse(JSON.stringify(event));
//           e.which = 40;
//           e.keyCode = 40;
//           _listener.apply(input, [e]);
//         }
//         _listener.apply(input, [event]);
//       };
//     }
//     _addEventListener.apply(input, [type, listener]);
//   };
//
//   input.addEventListener = addEventListenerWrapper;
//   input.attachEvent = addEventListenerWrapper;
// }
//
// // FIXME: Race condition 😡
// $(document).on('submit', 'header#video form:first, #search-sidebar-form', function (event) {
//   event.preventDefault();
//   // console.log('SUBMITTING', document.getElementsByClassName('pac-item').length)
//   setTimeout(function () {
//     // console.log('SUBMITTING 4 REAL', document.getElementsByClassName('pac-item').length)
//     event.target.submit();
//   }, 1500);
// });
//
// $(document).on('page:change', function () {
//   var field = document.getElementById('address-field');
//   if (field != null) {
//     var autocomplete = new google.maps.places.Autocomplete(field, {
//       componentRestrictions: { country: 'dk' }
//       // types: ['(cities)', 'postal_code'],
//       // types: ['(cities)'],
//     });
//
//     enableEnterKey(field);
//
//     autocomplete.addListener('place_changed', function () {
//       // console.log('PLACE CHANGED')
//
//       var place = autocomplete.getPlace();
//       if (!place.geometry) return;
//
//       var _place$geometry$locat = place.geometry.location,
//           lng = _place$geometry$locat.lng,
//           lat = _place$geometry$locat.lat;
//
//       document.getElementById('longitude-field').value = lng();
//       document.getElementById('latitude-field').value = lat();
//     });
//   }
// });
//
// // function enableEnterKey(input) {
// //   const _addEventListener = input.addEventListener
// //     ? input.addEventListener
// //     : input.attachEvent
// //
// //   const addEventListenerWrapper = (type, listener) => {
// //     if (type === 'keydown') {
// //       /* Store existing listener function */
// //       const _listener = listener
// //       listener = (event) => {
// //         /* Simulate a “down arrow” keypress if no address has been selected */
// //         const s = document.getElementsByClassName('pac-item-selected').length > 0
// //         if (event.which === 13 && !s) {
// //           const e = JSON.parse(JSON.stringify(event))
// //           e.which = 40
// //           e.keyCode = 40
// //           _listener.apply(input, [e])
// //         }
// //         _listener.apply(input, [event])
// //       }
// //     }
// //     _addEventListener.apply(input, [type, listener])
// //   }
// //
// //   input.addEventListener = addEventListenerWrapper
// //   input.attachEvent = addEventListenerWrapper
// // }
// //
// // // FIXME: Race condition 😡
// // $(document).on('submit', 'header#video form:first, #search-sidebar-form', event => {
// //   event.preventDefault()
// //   // console.log('SUBMITTING', document.getElementsByClassName('pac-item').length)
// //   setTimeout(() => {
// //     // console.log('SUBMITTING 4 REAL', document.getElementsByClassName('pac-item').length)
// //     event.target.submit()
// //   }, 150)
// // })
// //
// // $(document).on('page:change', () => {
// //   const field = document.getElementById('address-field')
// //   if (field != null) {
// //     const autocomplete = new google.maps.places.Autocomplete(field, {
// //       componentRestrictions: { country: 'dk' },
// //       // types: ['(cities)', 'postal_code'],
// //       // types: ['(cities)'],
// //     })
// //
// //     enableEnterKey(field)
// //
// //     autocomplete.addListener('place_changed', () => {
// //       // console.log('PLACE CHANGED')
// //
// //       const place = autocomplete.getPlace()
// //       if (!place.geometry) return
// //
// //       const { lng, lat } = place.geometry.location
// //       document.getElementById('longitude-field').value = lng()
// //       document.getElementById('latitude-field').value = lat()
// //     })
// //   }
// // })
