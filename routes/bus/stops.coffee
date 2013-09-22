stops = module.exports
transloc = require('../../lib/transloc')
redis = require('redis').createClient()
async = require('async')
_ = require('underscore')

# TODO: refactor out caching into lib
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
          redis.setex('bus:stops', 5*60, JSON.stringify(data))
          res.send data

stops.show = (req, res) ->
  async.parallel({
      route_id_map: (callback) ->
        transloc.route_id_to_name (err, data) ->
          callback(null, data)
      stops: (callback) ->
        redis.get('bus:stops', (err, data) ->
          if data
            callback(null, JSON.parse(data))
          else
            transloc.stop_list (err, data) ->
              if (err)
                res.send err
              else
                redis.setex('bus:stops', 5*60, JSON.stringify(data))
                callback(null, data)
        )
    },
    (err, results) ->
      if err
        res.send err
      else
        route_id_map = results.route_id_map
        stops = results.stops
        stop = _.find(stops, (stop) ->
          stop.id == req.params.stopId
        )
        stop.routes = _.map(stop.routes, (route) ->
          {
            id: route,
            name: route_id_map[route]
          }
        )
        res.send stop
  )
