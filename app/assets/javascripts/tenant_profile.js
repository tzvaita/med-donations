window.loadTenantsSearchResults = function(falseLoadOnMobile) {

  let path;
  if (falseLoadOnMobile == null) { falseLoadOnMobile = true; }
  const data = {
    'location': $('#geolocations').val(),
    'rooms': $('#rooms_range').val(),
    'area': $('#area_range').val(),
    'radius': $('#radius_range').val(),
    'rent': $('#rent_range').val(),
    'rent_per': $('#rent_per').val(),
    'property_types': $('select#property_type').val(),
    'rental_period': $('select#rental_period_tenant').val(),
    'profile_type': $('select#profile_type_tenant').val(),
    'order': $('#tenant-order-by').val()
  };

  // Delete blank/default values, to make urls prettier
  Object.keys(data).map(function(k){
    if (!!!data[k]) { return delete data[k]; }});

  if ($('body').hasClass('tenant_profiles_index')) {

    path = window.location.pathname;

  } else {
    const slugify = str => str.toString().toLowerCase().replace('århus', 'aarhus').replace(/^\s+|\s+$/g, '').replace('ø', 'o').replace('å', 'a').replace(/\s+/g, '-').replace(/-+/g, '-');
    // Finding an appropriate URL to use for the query. It may be the url of either a citypage of category `city`, one of category `frontpage`
    // or ultimately, we'll use the properties_path
    if (location && ($.inArray(slugify(location), window.searchConfig.city_page_slugs) > -1)) {
      path = [ window.searchConfig.search_properties_path, slugify(location) ].join('/');
      delete data.location;
    } else if (!location && data['property_types']) {
      path = window.searchConfig[data.property_types+'s_path'];
      delete data.property_types;
    } else {
      path = window.searchConfig.search_properties_path;
    }
  }

  let url = path;
  if (Object.keys(data).length !== 0) { url += '?' + $.param(data); }

  // On small screens, we have the filters hidden by default, so a turbolinks reload will ruin the user experience
  // so on small screens, we'll do a dry run only the fetch the number of results this search provides, until the user pushes the button
  // to get the actual results. Thats the explanation of the `falseLoadOnMobile` nonsense
  if ((window.innerWidth <= 768) && falseLoadOnMobile) {
    $.get(url, resp => $('#search-filters .submit-button-container .fb-button').html($(resp).find('.total-results').html()));
  } else {
    Turbolinks.visit(url);
  }
};
