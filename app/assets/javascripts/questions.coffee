jQuery ->
  $('#q').autocomplete(
    source: '/questions/autocomplete'
    minLength: 2
    select: (event, ui) ->
      $('#q2').val ui.item.id
      $(this).closest('form').trigger 'submit'
  ).keypress (e) ->
    if e.keyCode == 13
      $(this).closest('form').trigger 'submit'
  
# $("#q").autocomplete(
#     source: "/questions/autocomplete",
#     minLength: 2
#   )