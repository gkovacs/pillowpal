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
      $('#friendlist').autocomplete(
        {
          'autoFocus': true,
          'source': root.friendlist,
          'select': (event, ui) ->
            $('#friendlist').val(ui.item.value)
            $('#friendlist').submit()
            setTimeout(() ->
              $('#friendlist').val('')
            , 10)
        }
      )
    )
  )

now.refreshStatus = (targetuser, newstatus) ->
  if root.email == targetuser
    $('#status').text(newstatus)

accessPillow = root.accessPillow = () ->
  friendid = $('#friendlist').val()
  setTimeout(() ->
    $('#friendlist').val('')
  , 10)
  console.log friendid
  now.getFriendsAllowed(friendid, (allowedIds) ->
    if not allowedIds? or allowedIds.indexOf(myid) == -1
      $('#requestAccess').show()
  )
  return false

