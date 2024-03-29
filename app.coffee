express = require('express')
routes = require('./routes')
user = require('./routes/user')
bus = require ('./routes/bus')
http = require('http')
path = require('path')
app = express()

allowCrossDomain = (req, res, next) ->
    res.header('Access-Control-Allow-Origin', '*')
    res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS')
    res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization, Content-Length, X-Requested-With')
    if 'OPTIONS' == req.method
      res.send(200)
    else
      next()

app.configure ->
  app.use(allowCrossDomain)
  app.set 'port', process.env.PORT or 3000
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.favicon()
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(path.join(__dirname, 'public'))

app.configure 'development', ->
  app.use express.errorHandler()

app.get '/', routes.index
app.get '/users', user.list

app.get '/routes', bus.routes.index
app.get '/routes/:routeId', bus.routes.show

app.get '/stops', bus.stops.index
app.get '/stops/:stopId', bus.stops.show

http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get('port')

