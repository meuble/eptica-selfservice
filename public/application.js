
$(function() {
  var dataURL = "/data?callback=?";

  var displayChoices = function(data) {
    var result = $('#results');
    var resultUl = $('#results ul');
    resultUl.empty('');
    if (data.response) {
      $.each(data.response, function(i, e) {
        resultUl.append('<li><a>' + e + '</a></li>');
      });
    }
    result.show();
  }

  var fetchChoices = function(value) {
    $.getJSON(dataURL, {pattern: value}).done(function(data) {
      displayChoices(data)
    });
  };

  $('#pattern').on('keyup', function(event) {
    fetchChoices($(this).prop('value'));
  })

  if ($('#results').length > 0) {
    $('#results').hide();
  }

  $('body').on('click', function(event) {
    console.log($(event.target).closest("#results, #pattern"))

    if ($(event.target).closest("#results, #pattern").length <= 0) {
      $('#results').hide();
    }
  });
});