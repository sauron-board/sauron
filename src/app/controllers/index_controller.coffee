
# #Index Controller
module.exports = exports = new (require("locomotive").Controller)

# ##Dependencies
registry = require "../../lib/registry"

# ##Actions

# ###Index
exports.index = ->
  if @req.user
    @render user: @req.user
  else
    @render "landing"

exports.api = ->
  @plugins = registry.plugins
  @render format: "json"
