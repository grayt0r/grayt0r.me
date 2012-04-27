$ ->
  $('a[data-pjax]').pjax()
  
  $('#click-me').click ->
    alert 'Boo!!'
  
  