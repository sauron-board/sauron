experiment = require "experiment"
experiment.configure require "#{__dirname}/../experiments"

module.exports = (req, res, next) ->
  context = experiment.contextFor req.token, req.user?.id
  exps = experiment.readFor context, {}

  # Expose feature to the views
  res.locals.experiment = (feature)->
    experiment.feature feature, exps
  next()
