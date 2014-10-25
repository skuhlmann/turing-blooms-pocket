$ ->
  $('#time_of_day')
  .datepicker( changeYear: true, yearRange: '1904:1904' )
  $('#finger input').click (event) ->
    event.preventDefault()
    $.post(
      $('#finger form').attr('action')
      (data) -> $('#finger p').html(data)
      .effect('highlight', color: '#fcd')
		)
