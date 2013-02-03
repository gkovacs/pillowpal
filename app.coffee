express = require 'express'
app = express()
http = require 'http'
httpserver = http.createServer(app)
httpserver.listen(3333)
nowjs = require 'now'
everyone = nowjs.initialize(httpserver)

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
  # Initialize Passport!  Also use passport.session() middleware, to support
  # persistent login sessions (recommended).
  app.use(passport.initialize());
  app.use(passport.session());
  app.use(app.router);
  # end of fb authentication stuff
  app.use(express.static(__dirname + '/'))
)

#app.get '/', (req, res) ->
#  if req.query? and req.query.email? and req.query.name?
#    res.redirect('/setcookie.html?email=' + encodeURI(req.query.email) + '&name=' + encodeURI(req.query.name))
#  else
#    res.redirect('/login.html')


