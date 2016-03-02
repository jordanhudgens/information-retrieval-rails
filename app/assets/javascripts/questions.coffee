jQuery ->
  $('#q').autocomplete(
    source: '/questions/autocomplete'          #gives user a list of completed queries
    minLength: 2
    select: (event, ui) ->                     #event function for selecting
      $('#q2').val ui.item.id
      $(this).closest('form').trigger 'submit' #submits selection in single click 
  ).keypress (e) ->
    if e.keyCode == 13
      $(this).closest('form').trigger 'submit' #submits selection if user hits 'enter'
  
