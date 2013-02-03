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
        root.friendlist.push {'label': friend.name, 'value': friend.id}
      root.friendlist.push {'label': 'Myself', 'value': myid}
      $('#friendlist').autocomplete(
        {
          'autoFocus': true,
          'source': root.friendlist,
          'select': (event, ui) ->
            accessPillow(ui.item.value)
            console.log 'selected: ' + ui.item.value
            #$('#friendlist').val(ui.item.value)
            #$('#friendlist').submit()
            #setTimeout(() ->
            #  $('#friendlist').val('')
            #, 10)
        }
      )
    )
  )

now.refreshStatus = (targetuser, newstatus) ->
  if root.email == targetuser
    $('#status').text(newstatus)

targetid = -1

sendWakeup = root.sendWakeup = () ->
  if targetid == -1
    return
  volume = $('#volumeSlider').val()
  console.log 'sendWakeup sent!'
  console.log targetid
  console.log $('#wakeupsong').val()
  now.sendPlaySound(targetid, volume, $('#wakeupsong').val())

accessPillow = root.accessPillow = (friendid) ->
  if not friendid?
    friendid = $('#friendlist').val()
  targetid = friendid
  setTimeout(() ->
    $('#friendlist').val('')
  , 10)
  console.log friendid
  now.getFriendsAllowed(friendid, (allowedIds) ->
    if false # not allowedIds? or allowedIds.indexOf(myid) == -1
      $('#requestAccess').show()
    else
      $('#pillowcontrols').show()
  )
  return false

