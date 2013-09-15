routes = module.exports

routes.index = (req, res) ->
  res.send 'route list'

routes.show = (req, res) ->
  res.send "route id #{req.params.routeId}"
