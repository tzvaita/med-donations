window.setupGeolocationSearch = () => $('#geolocations').selectize({
  plugins: ['remove_button'],
  valueField: 'slug',
  labelField: 'title',
  searchField: 'title',
  sortField: 'title',
  create: false,
  closeAfterSelect: true,
  options: window.defaultGeolocationOptions(),
  items: window.selectedDefaultGeolocation(),
  optgroups: [
    { id: 'municipality', name: 'Kommun' },
    { id: 'city', name: 'Stad' },
  ],
  optgroupField: 'location_type',
  optgroupLabelField: 'name',
  optgroupValueField: 'id',
  optgroupOrder: ['municipality', 'city'],

  render: { option(item, escape) {
      return '<div class="option">' + item.title + '</div>';
    }
  },

  load(query, callback) {
    if (!query.length) {
      return callback();
    }
    $.ajax({
      url: '/geolocation/search.json?q=' + encodeURIComponent(query),
      type: 'GET',
      error() {
        callback();
      },
      success(res) {
        callback(res.geolocations);
      }
    });
  },

  onChange(value, item) {
    if ($('body').hasClass('pages_index') && (value.length > 0)) {
      window.loadSearchResults();
    } else if (($('body').hasClass('properties_index') || $('body').hasClass('errors_not_found')) || $('body').hasClass('city_pages_show')) {
      if ($('#geolocations').val() !== '') {
        window.loadSearchResults();
      }
    } else if ($('body').hasClass('tenant_profiles_index')) {
      window.loadTenantsSearchResults();
    }
  },

  onType(value, item) {
    $('#hdn-location').val(value);
  }
});

$(document).on('page:change', () => window.setupGeolocationSearch());


window.defaultGeolocationOptions  = function() {
  const option = $('#onPageDefaultGeolocationOptions');
  if (option.length === 1) {
    return [JSON.parse(option.html())];
  } else {
    return [];
  }
};

window.selectedDefaultGeolocation = function() {
  const option = $('#onPageSelectedDefaultGeolocation');
  if (option.length === 1) {
    return [option.html()];
  } else {
    return [];
  }
};
