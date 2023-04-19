'use strict';

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var formatParams = function formatParams(params) {
  return Object.keys(params).map(function (paramName) {
    var paramValue = params[paramName];
    return paramName + '=' + encodeURIComponent(paramValue);
  }).join('&');
};

var delay = function delay(ms) {
  return new Promise(function (resolve) {
    return setTimeout(resolve, ms);
  });
};

var defaultOptions = {
  params: {},
  minLength: 2,
  retryDelay: 500,
  renderCallback: function renderCallback() {
    /*eslint no-console: 0*/
    console.error('No renderCallback supplied');
  },
  initialRenderCallback: function initialRenderCallback() {
    /*eslint no-console: 0*/
    console.error('No initialRenderCallback supplied');
  },
  type: 'adresse',
  baseUrl: 'https://dawa.aws.dk',
  adgangsadresserOnly: false,
  stormodtagerpostnumre: true,
  supplerendebynavn: true,
  fuzzy: true,
  fetchImpl: function fetchImpl(url, params) {
    return fetch(url + '?' + formatParams(params), {
      mode: 'cors'
    }).then(function (result) {
      return result.json();
    });
  }
};

var AutocompleteController = function () {
  function AutocompleteController(options) {
    _classCallCheck(this, AutocompleteController);

    options = Object.assign({}, defaultOptions, options || {});
    this.options = options;
    this.state = {
      currentRequest: null,
      pendingRequest: null
    };
    this.selected = null;
  }

  _createClass(AutocompleteController, [{
    key: '_getAutocompleteResponse',
    value: function _getAutocompleteResponse(text, caretpos, skipVejnavn, adgangsadresseid, supplerendebynavn, stormodtagerpostnumre) {
      var params = Object.assign({}, this.options.params, {
        q: String(text) + '*',
        // type: this.options.type,
        // caretpos: caretpos,
        // supplerendebynavn: supplerendebynavn,
        // stormodtagerpostnumre: stormodtagerpostnumre,
        // multilinje: true
      });
      // if (this.options.fuzzy) {
      //   params.fuzzy = '';
      // }
      // if (adgangsadresseid) {
      //   params.adgangsadresseid = adgangsadresseid;
      // }
      // if (skipVejnavn) {
      //   params.startfra = 'adgangsadresse';
      // }

      return this.options.fetchImpl(this.options.baseUrl + '/postnumre', params);
    }
  }, {
    key: '_scheduleRequest',
    value: function _scheduleRequest(request) {
      if (this.state.currentRequest !== null) {
        this.state.pendingRequest = request;
      } else {
        this.state.currentRequest = request;
        this._executeRequest();
      }
    }
  }, {
    key: '_executeRequest',
    value: function _executeRequest() {
      var _this = this;

      var request = this.state.currentRequest;
      var adgangsadresseid = null;
      var skipVejnavn = false;
      var text = void 0,
          caretpos = void 0;
      if (request.selected) {
        var item = request.selected;
        if (item.type !== this.options.type) {
          adgangsadresseid = item.type === 'adgangsadresse' ? item.data.id : null;
          skipVejnavn = item.type === 'vejnavn';
          text = item.tekst;
          caretpos = item.caretpos;
        } else {
          this.options.selectCallback(item);
          this.selected = item;
          this._requestCompleted();
          return;
        }
      } else {
        text = request.text;
        caretpos = request.caretpos;
      }
      if (request.selectedId) {
        var params = {
          id: request.selectedId,
          type: this.options.type
        };
        return this.options.fetchImpl(this.options.baseUrl + '/postnumre', params).then(function (result) {
          return _this._handleResponse(request, result);
        }, function (error) {
          return _this._handleFailedRequest(request, error);
        });
      } else if (request.selected || request.text.length >= this.options.minLength) {
        this._getAutocompleteResponse(text, caretpos, skipVejnavn, adgangsadresseid, this.options.supplerendebynavn, this.options.stormodtagerpostnumre).then(function (result) {
          return _this._handleResponse(request, result);
        }, function (error) {
          return _this._handleFailedRequest(request, error);
        });
      } else {
        this._handleResponse(request, []);
      }
    }
  }, {
    key: '_handleFailedRequest',
    value: function _handleFailedRequest(request, error) {
      var _this2 = this;

      console.error('DAWA request failed', error);
      return delay(this.options.retryDelay).then(function () {
        if (!_this2.state.pendingRequest) {
          _this2._scheduleRequest(request);
        }
        _this2._requestCompleted();
      });
    }
  }, {
    key: '_handleResponse',
    value: function _handleResponse(request, result) {
      if (request.selected) {
        if (result.length === 1) {
          var item = result[0];
          if (item.type === this.options.type) {
            this.options.selectCallback(item);
          } else {
            if (!this.state.pendingRequest) {
              this.state.pendingRequest = {
                selected: item
              };
            }
          }
        } else if (this.options.renderCallback) {
          this.options.renderCallback(result);
        }
      } else if (request.selectedId) {
        if (result.length === 1) {
          this.selected = result[0];
          this.options.initialRenderCallback(result[0].tekst);
        }
      } else {
        if (this.options.renderCallback) {
          this.options.renderCallback(result);
        }
      }
      this._requestCompleted();
    }
  }, {
    key: '_requestCompleted',
    value: function _requestCompleted() {
      this.state.currentRequest = this.state.pendingRequest;
      this.state.pendingRequest = null;
      if (this.state.currentRequest) {
        this._executeRequest();
      }
    }
  }, {
    key: 'setRenderCallback',
    value: function setRenderCallback(renderCallback) {
      this.options.renderCallback = renderCallback;
    }
  }, {
    key: 'setInitialRenderCallback',
    value: function setInitialRenderCallback(renderCallback) {
      this.options.initialRenderCallback = renderCallback;
    }
  }, {
    key: 'setSelectCallback',
    value: function setSelectCallback(selectCallback) {
      this.options.selectCallback = selectCallback;
    }
  }, {
    key: 'update',
    value: function update(text, caretpos) {
      var request = {
        text: text,
        caretpos: caretpos
      };
      this._scheduleRequest(request);
    }
  }, {
    key: 'select',
    value: function select(item) {
      var request = {
        selected: item
      };
      this._scheduleRequest(request);
    }
  }, {
    key: 'selectInitial',
    value: function selectInitial(id) {
      var request = {
        selectedId: id
      };
      this._scheduleRequest(request);
    }
  }, {
    key: 'destroy',
    value: function destroy() {}
  }]);

  return AutocompleteController;
}();

IncrementalDOM.attributes.caretpos = function (element, name, value) {
  element.setSelectionRange(value, value);
};

IncrementalDOM.attributes.value = IncrementalDOM.applyProp;

var renderIncrementalDOM = function renderIncrementalDOM(data, onSelect, multiline) {
  console.dir(data)

  if (data.suggestions.length > 0 && data.focused) {
    IncrementalDOM.elementOpen('ul', '', ['class', 'dawa-autocomplete-suggestions', 'role', 'listbox']);

    var _loop = function _loop(i) {
      var suggestion = data.suggestions[i];
      var className = 'dawa-autocomplete-suggestion';
      if (data.selected === i) {
        className += ' dawa-selected';
      }
      IncrementalDOM.elementOpen('li', '', ['role', 'option'], 'class', className, 'onmousedown', function (e) {
        onSelect(i);
        e.preventDefault();
      });
      // var rows = suggestion.forslagstekst.split('\n');
      // rows = rows.map(function (row) {
      //   return row.replace(/ /g, '\xA0');
      // });
      // if (multiline) {
      //   IncrementalDOM.text(rows[0]);
      //   for (var _i = 1; _i < rows.length; ++_i) {
      //     IncrementalDOM.elementVoid('br');
      //     IncrementalDOM.text(rows[_i]);
      //   }
      // } else {
      //   IncrementalDOM.text(rows.join(', '));
      // }
      IncrementalDOM.text([suggestion.nr, suggestion.navn].join(' '));
      IncrementalDOM.elementClose('li');
    };

    for (var i = 0; i < data.suggestions.length; ++i) {
      _loop(i);
    }
    IncrementalDOM.elementClose('ul');
  }
};

var defaultRender = function defaultRender(containerElm, data, onSelect, multiline) {
  IncrementalDOM.patch(containerElm, function () {
    renderIncrementalDOM(data, onSelect, multiline);
  });
};

var autocompleteUi = function autocompleteUi(inputElm, options) {
  var onSelect = options.onSelect;
  var onTextChange = options.onTextChange;
  var render = options.render || defaultRender;

  var destroyed = false;
  var lastEmittedText = '';
  var lastEmittedCaretpos = 0;
  var suggestionContainerElm = document.createElement('div');
  inputElm.parentNode.insertBefore(suggestionContainerElm, inputElm.nextSibling);

  var emitTextChange = function emitTextChange(newText, newCaretpos) {
    if (lastEmittedText !== newText || lastEmittedCaretpos !== newCaretpos) {
      onTextChange(newText, newCaretpos);
      lastEmittedText = newText;
      lastEmittedCaretpos = newCaretpos;
    }
  };

  var data = {
    caretpos: 2,
    inputText: '',
    selected: 0,
    focused: document.activeElement === inputElm,
    suggestions: []
  };

  var handleInputChanged = function handleInputChanged(inputElm) {
    var newText = inputElm.value;
    var newCaretPos = inputElm.selectionStart;
    data.caretpos = newCaretPos;
    data.inputText = newText;
    emitTextChange(newText, newCaretPos);
  };

  var update = void 0;

  var selectSuggestion = function selectSuggestion(index) {
    var selectedSuggestion = data.suggestions[index];
    // data.inputText = selectedSuggestion.tekst;
    data.inputText = [selectedSuggestion.nr, selectedSuggestion.navn].join(' ');
    data.caretpos = selectedSuggestion.caretpos;
    data.suggestions = [];
    onSelect(selectedSuggestion);
    update(true);
  };

  var keydownHandler = function keydownHandler(e) {
    var key = window.event ? e.keyCode : e.which;
    if (data.suggestions.length > 0 && data.focused) {
      // down (40)
      if (key === 40) {
        data.selected = (data.selected + 1) % data.suggestions.length;
        update();
      }
      //up (38)
      else if (key === 38) {
          data.selected = (data.selected - 1 + data.suggestions.length) % data.suggestions.length;
          update();
        }
        // enter
        else if (key === 13 || key === 9) {
            selectSuggestion(data.selected);
          } else {
            return true;
          }
      e.preventDefault();
      return false;
    }
  };

  var focusHandler = function focusHandler() {
    data.focused = true;
    update();
  };

  var blurHandler = function blurHandler() {
    data.focused = false;
    update();
    return false;
  };

  var inputChangeHandler = function inputChangeHandler(e) {
    handleInputChanged(e.target);
  };
  var inputMouseUpHandler = function inputMouseUpHandler(e) {
    return handleInputChanged(e.target);
  };

  var updateScheduled = false;
  var updateInput = false;
  update = function update(shouldUpdateInput) {
    if (shouldUpdateInput) {
      updateInput = true;
    }
    if (!updateScheduled) {
      updateScheduled = true;
      requestAnimationFrame(function () {
        if (destroyed) {
          return;
        }
        updateScheduled = false;
        if (updateInput) {
          inputElm.value = data.inputText;
          // inputElm.setSelectionRange(data.caretpos, data.caretpos);
        }
        updateInput = false;
        render(suggestionContainerElm, data, function (i) {
          return selectSuggestion(i);
        }, options.multiline);
      });
    }
  };

  update();

  var destroy = function destroy() {
    destroyed = true;
    inputElm.removeEventListener('keydown', keydownHandler);
    inputElm.removeEventListener('blur', blurHandler);
    inputElm.removeEventListener('focus', focusHandler);
    inputElm.removeEventListener('input', inputChangeHandler);
    inputElm.removeEventListener('mouseup', inputMouseUpHandler);
    IncrementalDOM.patch(suggestionContainerElm, function () {});
    suggestionContainerElm.remove();
  };

  var setSuggestions = function setSuggestions(suggestions) {
    data.suggestions = suggestions;
    data.selected = 0;
    update();
  };

  var selectAndClose = function selectAndClose(text) {
    data.inputText = text;
    data.caretpos = text.length;
    data.suggestions = [];
    data.selected = 0;
    update(true);
  };

  inputElm.addEventListener('keydown', keydownHandler);
  inputElm.addEventListener('blur', blurHandler);
  inputElm.addEventListener('focus', focusHandler);
  inputElm.addEventListener('input', inputChangeHandler);
  inputElm.addEventListener('mouseup', inputMouseUpHandler);
  inputElm.setAttribute('aria-autocomplete', 'list');
  inputElm.setAttribute('autocomplete', 'off');

  return {
    destroy: destroy,
    setSuggestions: setSuggestions,
    selectAndClose: selectAndClose
  };
};

function dawaAutocomplete(inputElm, options) {
  options = Object.assign({ select: function select() {
      return null;
    } }, options);
  var controllerOptions = ['baseUrl', 'minLength', 'params', 'fuzzy', 'stormodtagerpostnumre', 'supplerendebynavn'].reduce(function (memo, optionName) {
    if (options.hasOwnProperty(optionName)) {
      memo[optionName] = options[optionName];
    }
    return memo;
  }, {});
  if (options.adgangsadresserOnly) {
    controllerOptions.type = 'adgangsadresse';
  } else {
    controllerOptions.type = 'adresse';
  }
  var controller = new AutocompleteController(controllerOptions);
  var ui = autocompleteUi(inputElm, {
    onSelect: function onSelect(suggestion) {
      console.log('onSelect!!!!', suggestion);
      document.getElementById('longitude-field').value = suggestion.visueltcenter[0];
      document.getElementById('latitude-field').value = suggestion.visueltcenter[1];
      controller.select(suggestion);
    },
    onTextChange: function onTextChange(newText, newCaretpos) {
      controller.update(newText, newCaretpos);
    },
    render: options.render,
    multiline: options.multiline || false
  });
  controller.setRenderCallback(function (suggestions) {
    return ui.setSuggestions(suggestions);
  });
  controller.setSelectCallback(function (selected) {
    ui.selectAndClose(selected.tekst);
    options.select(selected);
  });
  controller.setInitialRenderCallback(function (text) {
    return ui.selectAndClose(text);
  });
  if (options.id) {
    controller.selectInitial(options.id);
  }
  return {
    id: function id(_id) {
      return controller.selectInitial(_id);
    },
    destroy: function destroy() {
      return ui.destroy();
    },
    selected: function selected() {
      return controller.selected;
    }
  };
}

$(document).on('page:change', function () {
  if (document.getElementById('address-field')) {
    dawaAutocomplete(document.getElementById('address-field'), {});
  }
})
