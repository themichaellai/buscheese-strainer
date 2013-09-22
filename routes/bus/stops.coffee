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
      route_id_map: (callback) ->
        transloc.route_id_to_name (err, data) ->
          callback(null, data)
      stops: (callback) ->
        transloc.stop_list (err, data) ->
          if (err)
            res.send err
          else
            callback(null, data)
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
