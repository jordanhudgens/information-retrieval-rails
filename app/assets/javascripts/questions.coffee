jQuery ->
  $("#q").autocomplete(
    source: "/questions/autocomplete",
    minLength: 2
  )