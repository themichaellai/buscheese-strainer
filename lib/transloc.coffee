config = require('../config')
_ = require('underscore')
request = require('request')

transloc = module.exports

transloc.route_list = (callback) ->
  request "http://api.transloc.com/1.2/routes.json?agencies=#{config.AGENCY_ID}", (err, res, body) ->
    if (err)
      console.log err
    else
      try
        body_json = JSON.parse(body)
      catch e
        callback({error: body})

      if 'data' of body_json and config.AGENCY_ID of body_json.data
        data = _.map(body_json.data[config.AGENCY_ID], (route) ->
          return {
            long_name: route.long_name,
            stops: route.stops,
            route_id: route.route_id,
            is_active: route.is_active,
          }
        )
        callback(null, data)
      else
        callback(body_json)
