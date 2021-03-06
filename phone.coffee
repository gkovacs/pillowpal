root = exports ? this

now.ready () ->
  FB.getLoginStatus((loginStatus) ->
    if not loginStatus? or not loginStatus.authResponse? or not loginStatus.authResponse.accessToken?
      window.location = '/auth/facebook'
      return
    userid = loginStatus.authResponse.userID
    console.log 'nowjs initialized'
    $('#username').text(userid)
    now.getStatus(userid, (status) ->
      $('#status').text(status)
    )
    root.friendlist = []
    FB.api('/me/friends', (response) ->
      if not response? or not response.data?
        window.location = '/auth/facebook'
      for friend in response.data
        console.log friend
        root.friendlist.push friend.name
      $('#friendlist').autocomplete(
        {
          'autoFocus': true,
          'source': root.friendlist,
        }
      )
    )
  )

now.playSound = root.playSound = playSound = (targetuser, volume, soundfile) ->
  setbackground()
  console.log 'play sound received'
  if myid != targetuser
    return
  console.log 'playig sound!'
  setInterval(() ->
    $('audio')[0].play()
  , 1000)
  $('audio')[0].src = 'totalTone_500.wav'
  $('audio')[0].volume = 1.0
  $('audio')[0].play()

now.refreshStatus = (targetuser, newstatus) ->
  if myid == targetuser
    $('#status').text(newstatus)

