
module.exports = ->

  @match "plugins/:plugin_id", "plugins#index"
  @match "plugins/:plugin_id/items/:id", "plugins#show"
  @match "plugins/:plugin_id/webhook", "plugins#receive", via: "post"
  @match "plugins/:plugin_id/commands/:id", "commands#show"

  # /
  @match "api", "index#api"
  @root "index#index"
