stops = module.exports
transloc = require('../../lib/transloc')
redis = require('redis').createClient()

stops.index = (req, res) ->
  redis.get 'bus:stops', (err, data) ->
    if data
      res.header('Content-Type', 'application/json; charset=utf-8')
      res.send JSON.parse(data)
    else
      transloc.stop_list (err, data) ->
        if (err)
          res.send err
        else
          redis.setex('bus:stops', 10, JSON.stringify(data))
          res.send data

stops.show = (req, res) ->
  res.send {}
