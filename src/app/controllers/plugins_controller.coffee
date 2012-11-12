
# #Plugin Controller
module.exports = exports = new (require("locomotive").Controller)

# ##Includes
async = require "async"

# ###Libraries

# ###Models
registry = require "../../lib/registry"
{Publication} = require "../models"

# ##Defines

# ##Actions

# ###Index
exports.index = ->
  @plugin_id = @param "plugin_id"
  @render format: "json"

# ###Show
exports.show = ->
  @plugin_id = @param "plugin_id"
  @id = id = @param "id"
  @render format: "json"

# ###Receive
exports.receive = ->
  res = @res
  registry.webhook @param("plugin_id"), @req, (error)->
    res.send if error then 500 else 200

# ##Hooks

# ###Index
exports.before "index", (done)->
  self = @
  id = @param "plugin_id"

  if not registry.exists id
    error = new Error("#{id} could not be found")
    error.status = 404
    return done error

  async.parallel {
    properties: (next)-> registry.properties id, next
    links: (next)-> registry.links id, next
    commands: (next)-> registry.commands id, next
    feed: (next)->
      options =
        where:
          collection: id
        order: "date DESC"
        limit: 10

      Publication.all options, (err, publications)->
        return next err if err
        publicationsData = []
        for publication in publications
          pub = JSON.parse publication.data
          pub.id = publication.id
          publicationsData.push pub
        
        next null, publicationsData
        
      
  }, (err, results)->
    self.properties = results.properties
    self.links = results.links
    self.commands = results.commands
    self.feed = results.feed
    done()


# ###Show
exports.before "show", (done)->
  self = @
  plugin_id = @param "plugin_id"
  id = @param "id"

  if not registry.exists id
    error = new Error("#{id} could not be found")
    error.status = 404
    return done error

  async.parallel {
    properties: (next)-> registry.properties plugin_id, next
    links: (next)-> registry.links plugin_id, next
    commands: (next)-> registry.commands plugin_id, next
    feed: (next)->
      options =
        where:
          collection: plugin_id
          pub_id: id

      Publication.findOne options, next
  }, (err, results)->
    self.properties = results.properties
    self.links = results.links
    self.commands = results.commands
    self.feed = results.feed
    done()
