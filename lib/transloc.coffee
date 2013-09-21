config = require('../config')
_ = require('underscore')
request = require('request')

transloc = module.exports

transloc.route_list = (callback) ->
  request "http://api.transloc.com/1.2/routes.json?agencies=#{config.AGENCY_ID}", (err, res, body) ->
    if (err)
      console.log err
    else
      if res.statusCode in [400, 500]
        callback({error: body})
      else
        body_json = JSON.parse(body).data[config.AGENCY_ID]
        data = (
          {
            name: route.long_name,
            stops: route.stops,
            id: route.route_id,
            is_active: route.is_active,
          } for route in body_json when route.is_active)
        callback(null, data)

transloc.stop_list = (callback) ->
  request "http://api.transloc.com/1.2/stops.json?agencies=#{config.AGENCY_ID}", (err, res, body) ->
    if (err)
      console.log err
    else
      if res.statusCode in [400, 500]
        callback({error: body})
      else
        body_json = JSON.parse(body).data
        data = (
          {
            name: stop.name,
            routes: stop.routes,
            id: stop.stop_id,
          } for stop in body_json)
        callback(null, data)
