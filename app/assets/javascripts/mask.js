function setMasks() {
  var default_setup = {
    'alias': 'numeric',
    'groupSeparator': '.',
    'autoGroup': true,
    'radixPoint': ",",
    'digitsOptional': false,
    'allowMinus': false,
    'placeholder': '0',
    'autoUnmask': true,
    'rightAlign': false,
    'unmaskAsNumber': true,
    'removeMaskOnSubmit': true
  };

  $('.mask.currency_value').inputmask('decimal', $.extend(default_setup, {digits: 2}));
}

$(document).on('ready page:load', setMasks);
