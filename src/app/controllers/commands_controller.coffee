
# #Commands Controller
module.exports = exports = new (require("locomotive").Controller)

# ##Includes

# ###Libraries

# ###Models

# ##Defines

# ##Actions

# ###Index
exports.index = ->
  @render format: "json"
