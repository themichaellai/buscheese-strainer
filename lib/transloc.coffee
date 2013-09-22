config = require('../config')
_ = require('underscore')
request = require('request')
redis = require('redis').createClient()

transloc = module.exports

transloc.route_id_to_name = (callback) ->
  redis.get 'route_mapping', (err, data) ->
    if data
      callback(null, JSON.parse(data))
    else
      request "http://api.transloc.com/1.2/routes.json?agencies=#{config.AGENCY_ID}", (err, res, body) ->
        if (err)
          console.log err
          callback(err)
        else
          if res.statusCode in [400, 500]
            callback({error: body})
          else
            routes = JSON.parse(body).data[config.AGENCY_ID]
            mapping = _.object(_.map routes, (route) ->
              return [route.route_id, route.long_name]
            )
            redis.setex('route_mapping', 5*60, JSON.stringify(mapping))
            callback(null, mapping)

transloc.route_list = (callback) ->
  redis.get 'route_list', (err, data) ->
    if data
      callback(null, JSON.parse(data))
    else
      request "http://api.transloc.com/1.2/routes.json?agencies=#{config.AGENCY_ID}", (err, res, body) ->
        if (err)
          console.log err
          callback(err)
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
            redis.setex('route_list', 5*60, JSON.stringify(data))
            callback(null, data)


transloc.stop_id_to_name = (callback) ->
  redis.get 'stop_mapping', (err, data) ->
    if data
      callback(null, JSON.parse(data))
    else
      request "http://api.transloc.com/1.2/stops.json?agencies=#{config.AGENCY_ID}", (err, res, body) ->
        if (err)
          console.log err
          callback(err)
        else
          if res.statusCode in [400, 500]
            callback({error: body})
          else
            stops = JSON.parse(body).data
            mapping = _.object(_.map stops, (stop) ->
              return [stop.id, stop.name]
            )
            redis.setex('stop_mapping', 5*60, JSON.stringify(mapping))
            callback(null, mapping)

transloc.stop_list = (callback) ->
  redis.get 'stop_list', (err, data) ->
    if data
      callback(null, JSON.parse(data))
    else
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
            redis.setex('stop_list', 5*60, JSON.stringify(data))
            callback(null, data)

transloc.arrival_estimates = (callback) ->
  redis.get 'arrival_estimates', (err, data) ->
    if data
      callback(null, JSON.parse(data))
    else
      request "http://api.transloc.com/1.2/arrival-estimates.json?agencies=#{config.AGENCY_ID}", (err, res, body) ->
        if (err)
          console.log err
          callback(err)
        else
          if res.statusCode in [400, 500]
            callback({error: body})
          else
            stops = JSON.parse(body).data
            mapping = _.object(_.map stops, (stop) ->
              return [stop.stop_id, stop.arrivals]
            )
            redis.setex('arrival_estimates', 10, JSON.stringify(mapping))
            callback(null, mapping)
