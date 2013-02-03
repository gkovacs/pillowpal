root = exports ? this

myuser = 'geza'

now.ready () ->
  console.log 'nowjs initialized'
  $('#username').text(myuser)
  now.getStatus myuser, (status) ->
    $('#status').text(status)
  

