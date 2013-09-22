stops = module.exports
transloc = require('../../lib/transloc')
async = require('async')
_ = require('underscore')

stops.index = (req, res) ->
  transloc.stop_list (err, data) ->
    if (err)
      res.send err
    else
      res.send data

stops.show = (req, res) ->
  async.parallel({
      route_id_name_map: (callback) ->
        transloc.route_id_to_name (err, data) ->
          if err
            callback(err)
          callback(null, data)
      stops: (callback) ->
        transloc.stop_list (err, data) ->
          if err
            callback(err)
          else
            callback(null, data)
      arrivals: (callback) ->
        transloc.arrival_estimates (err, data) ->
          if err
            callback(err)
          else
            callback(null, data)
    },
    (err, results) ->
      if err
        res.send err
      else
        stop = _.find(results.stops, (stop) ->
          stop.id == req.params.stopId
        )
        delete stop.routes
        stop.arrivals = _.map(results.arrivals[req.params.stopId], (route) ->
          {
            route_id: route.route_id,
            name: results.route_id_name_map[route.route_id],
            arrival_at: route.arrival_at
          }
        )
        res.send stop
  )
