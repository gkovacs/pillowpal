root = exports ? this

now.ready () ->
  email = root.email = $.cookie('pillowemail')
  if not email?
    window.location = '/auth/facebook'
  else
    email = root.email = email.split('http://www.facebook.com/').join('')
  fullname = root.fullname = $.cookie('pillowfullname')
  console.log 'nowjs initialized'
  $('#username').text(email)
  now.getStatus email, (status) ->
    $('#status').text(status)
  root.friendlist = []
  FB.api('/me/friends', (response) ->
    if not response?
      window.location = '/auth/facebook'
    $('#friendinvitelist').html('')
    for friend in response.data
      console.log friend
      root.friendlist.push friend.name
      $('#friendinvitelist').append($('<input>').addClass('invitableFriend').attr('friendname', friend.name).attr('friendid', friend.id).attr('type', 'checkbox')).append(friend.name).append('<br>')
  )

friendsInvited = root.friendsInvited = () ->
  allowedFriendIds = []
  for friend in $('.invitableFriend')
    friendname = $(friend).attr('friendname')
    friendid = $(friend).attr('friendid')
    if $(friend).is(':checked')
      allowedFriendIds.push friendid
  console.log 'invited friends'
  now.setFriendsAllowed(myid, allowedFriendIds) # myid is initialized in the js in invitetopillow.coffee

now.refreshStatus = (targetuser, newstatus) ->
  if root.email == targetuser
    $('#status').text(newstatus)

