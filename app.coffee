express = require 'express'
app = express()
http = require 'http'
httpserver = http.createServer(app)
httpserver.listen(5678)
nowjs = require 'now'
everyone = nowjs.initialize(httpserver)

redis = require 'redis'
rclient = redis.createClient()

app.configure('development', () ->
  app.use(express.errorHandler())
)

app.configure( ->
  app.set('views', __dirname + '/views')
  app.set('view engine', 'ejs')
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
  app.use(app.router);
  # end of fb authentication stuff
  app.use(express.static(__dirname + '/'))
)

userStatus = {}

everyone.now.getStatus = (username, callback) ->
  if not userStatus[username]?
    userStatus[username] = 'asleep'
  if callback?
    callback userStatus[username]


everyone.now.setStatus = (username, newstatus, callback) ->
  userStatus[username] = newstatus
  if callback?
    callback newstatus

#app.get '/', (req, res) ->
#  if req.query? and req.query.email? and req.query.name?
#    res.redirect('/setcookie.html?email=' + encodeURI(req.query.email) + '&name=' + encodeURI(req.query.name))
#  else
#    res.redirect('/login.html')


