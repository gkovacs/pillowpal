express = require 'express'
app = express()
http = require 'http'
httpserver = http.createServer(app)
httpserver.listen(5678)
nowjs = require 'now'
everyone = nowjs.initialize(httpserver)

passport = require('passport')
FacebookStrategy = require('passport-facebook').Strategy

FACEBOOK_APP_ID = '123681104472943'
FACEBOOK_APP_SECRET = '9115798d61b57d41b5e10b66f49e86a0'
hostname = require('os').hostname()
if hostname == 'psetparty'
  FACEBOOK_APP_ID = '464385110294754'
  FACEBOOK_APP_SECRET = '0a31a7644246d7681bd2ef874a6bf0e7'

# Passport session setup.
#   To support persistent login sessions, Passport needs to be able to
#   serialize users into and deserialize users out of the session.  Typically,
#   this will be as simple as storing the user ID when serializing, and finding
#   the user by ID when deserializing.  However, since this example does not
#   have a database of user records, the complete Facebook profile is serialized
#   and deserialized.
passport.serializeUser((user, done) ->
  done(null, user)
)

passport.deserializeUser((obj, done) ->
  done(null, obj)
)


# Use the FacebookStrategy within Passport.
#   Strategies in Passport require a `verify` function, which accept
#   credentials (in this case, an accessToken, refreshToken, and Facebook
#   profile), and invoke a callback with a user object.
passport.use(new FacebookStrategy({
    clientID: FACEBOOK_APP_ID,
    clientSecret: FACEBOOK_APP_SECRET,
    callbackURL: "/auth/facebook/callback",
  }, (accessToken, refreshToken, profile, done) ->
    # asynchronous verification, for effect...
    process.nextTick( () ->
      # To keep the example simple, the user's Facebook profile is returned to
      # represent the logged-in user.  In a typical application, you would want
      # to associate the Facebook account with a user record in your database,
      # and return that user instead.
      return done(null, profile);
    )
))


ejs = require 'ejs'
ejs.open = '{{'
ejs.close = '}}'

#redis = require 'redis'
#rclient = redis.createClient()

app.configure('development', () ->
  app.use(express.errorHandler())
)

app.configure( ->
  app.set('views', __dirname + '/')
  app.set('view engine', 'ejs')
  app.engine('html', ejs.renderFile);
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.set('view options', { layout: false })
  app.locals({ layout: false })
  # fb authentication stuff
  app.use(express.logger());
  app.use(express.cookieParser());
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.session({ secret: 'keyboard cat' }));
  # Initialize Passport!  Also use passport.session() middleware, to support
  # persistent login sessions (recommended).
  app.use(passport.initialize());
  app.use(passport.session());
  app.use(app.router);
  # end of fb authentication stuff
  app.use(express.static(__dirname + '/'))
)

app.get '/invitetopillow', (req, res) ->
  res.render('invitetopillow.html', {'app_id': FACEBOOK_APP_ID})

app.get '/accesspillow', (req, res) ->
  res.render('accesspillow.html', {'app_id': FACEBOOK_APP_ID})

app.get '/', (req, res) ->
  res.render('index.html', {'app_id': FACEBOOK_APP_ID})


app.get '/phone', (req, res) ->
  res.render('phone.html', {'app_id': FACEBOOK_APP_ID})

# GET /auth/facebook
#   Use passport.authenticate() as route middleware to authenticate the
#   request.  The first step in Facebook authentication will involve
#   redirecting the user to facebook.com.  After authorization, Facebook will
#   redirect the user back to this application at /auth/facebook/callback
app.get('/auth/facebook', passport.authenticate('facebook'), (req, res) ->
  # The request will be redirected to Facebook for authentication, so this
  # function will not be called.
)

# GET /auth/facebook/callback
#   Use passport.authenticate() as route middleware to authenticate the
#   request.  If authentication fails, the user will be redirected back to the
#   login page.  Otherwise, the primary route function function will be called,
#   which, in this example, will redirect the user to the home page.
app.get('/auth/facebook/callback', passport.authenticate('facebook', { failureRedirect: '/login.html' }), (req, res) ->
  #res.redirect('/setcookie.html?email=' + encodeURI(req.user.profileUrl) + '&name=' + encodeURI(req.user.displayName))
  res.redirect('/')
)



userStatus = {}

userList = {}

everyone.now.getStatus = (username, callback) ->
  if not userStatus[username]?
    userStatus[username] = 'asleep'
  if callback?
    callback userStatus[username]


everyone.now.setStatus = (username, newstatus, callback) ->
  userStatus[username] = newstatus
  if callback?
    callback newstatus
  everyone.now.refreshStatus(username, newstatus)

allowedFriends = {}
#friendIdToName = {}

everyone.now.setFriendsAllowed = (userid, allowedFriendList) ->
  allowedFriends[userid] = allowedFriendList

everyone.now.getFriendsAllowed = (userid, callback) ->
  callback(allowedFriends[userid])

app.get '/allowedfriends', (req, res) ->
  userid = req.query.userid
  res.end JSON.stringify(allowedFriends[userid])

lyrics_getter = require './lyrics_getter'

everyone.now.sendChangeVolume = sendChangeVolume = (targetuser, volume) ->
  everyone.now.setVolume(targetuser, volume)

everyone.now.sendPlaySound = sendPlaySound = (targetuser, volume, soundfile) ->
  console.log 'sendPlaySound sent!'
  console.log targetuser
  console.log volume
  console.log soundfile
  if soundfile.indexOf('.wav') != -1 and soundfile.indexOf('.mp3') != -1
    everyone.now.playSound(targetuser, volume, soundfile)
  else
    lyrics_getter.getTitleLyricsVideoFromString(soundfile, (title, lyrics, video) ->
      everyone.now.playSound(targetuser, volume, video)
    )

app.get '/playsound', (req, res) ->
  userid = req.query.userid
  volume = req.query.volume
  soundfile = req.query.soundfile
  sendPlaySound(userid, volume, soundfile)
  res.end 'send sound'

#app.get '/', (req, res) ->
#  if req.query? and req.query.email? and req.query.name?
#    res.redirect('/setcookie.html?email=' + encodeURI(req.query.email) + '&name=' + encodeURI(req.query.name))
#  else
#    res.redirect('/login.html')


