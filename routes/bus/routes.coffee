routes = module.exports
transloc = require('../../lib/transloc')

routes.index = (req, res) ->
  console.log 'index'
  transloc.route_list((err, data) ->
    if (err)
      res.send err
    else
      res.send data
  )

routes.show = (req, res) ->
  res.send "route id #{req.params.routeId}"
