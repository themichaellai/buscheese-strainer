stops = module.exports
transloc = require('../../lib/transloc')

stops.index = (req, res) ->
  transloc.stop_list (err, data) ->
    if (err)
      res.send err
    else
      res.send data

stops.show = (req, res) ->
  res.send {}
