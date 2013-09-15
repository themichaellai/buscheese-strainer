stops = module.exports

stops.index = (req, res) ->
  res.send 'stop list'

stops.show = (req, res) ->
  res.send "stop id #{req.params.stopId}"
