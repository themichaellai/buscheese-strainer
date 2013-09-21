routes = module.exports
transloc = require('../../lib/transloc')

routes.index = (req, res) ->
  redis.get 'bus:routes', (err, data) ->
    if data
      res.header('Content-Type', 'application/json; charset=utf-8')
      res.send JSON.parse(data)
    else
      transloc.route_list (err, data) ->
        if (err)
          res.send err
        else
          redis.setex('bus:routes', 10, JSON.stringify(data))
          res.send data

routes.show = (req, res) ->
  res.send {}
