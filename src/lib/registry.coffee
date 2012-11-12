async = require "async"
_ = require "underscore"
{Publication} = require "../app/models"

module.exports.plugins = {}

module.exports.load = (name, module, options, config, emitter, next)->
  webhookPath = buildWebhook options.name

  settings =
    module: module
    config: config
    displayName: options.displayName
    render: options.render
    webhookPath: webhookPath
    webhook: "http://#{process.env.HOST}#{webhookPath}"
    emitter:
      emit: (id, item, done=()->)->

        Publication.findOne {where: {collection: name, pub_id: id}}, (err, publication)->
          publication = new Publication if not publication
          publication.pub_id = id
          pub_data = JSON.stringify item
          return done() if pub_data == publication.data

          publication.data = pub_data
          publication.collection = name
          publication.date = item.date if item?.date?
          publication.save (err)->
            return done err if err

            href = "#{process.env.HOST}/plugins/#{name}/items/#{id}"
            emitter.emit href, item, name, done

      retract: (id, done)->

        Publication.findOne {where: {collection: name, pub_id: id}}, (err, publication)->
          return done err if err or not publication
          publication.destroy (err)->
            return done err if err
            # Send out the retract event
            href = "#{process.env.HOST}/plugins/#{name}/items/#{id}"
            emitter.retract href, name, done

  console.log "info: '#{name}' initializing..."
  module.init settings.webhook, config, (err, state)->
    return next err if err
    settings.state = state
    exports.plugins[name] = settings
    console.log "info: '#{name}' initialized"
    next()

module.exports.exists = (name)->
  module.exports.plugins[name]?

module.exports.properties = (name, done)->
  plugin = exports.plugins[name]
  return done(null, []) if not plugin?.module?.properties?
  plugin?.module?.properties plugin.state, done

module.exports.links = (name, done)->
  plugin = exports.plugins[name]
  return done(null, []) if not plugin?.module?.links?
  plugin?.module?.links plugin.state, done

module.exports.commands = (name, done)->
  plugin = exports.plugins[name]
  return done(null, []) if not plugin?.module?.commands?
  plugin?.module?.commands plugin.state, done

module.exports.webhook = (name, req, done)->
  plugin = exports.plugins[name]

  return done() if not plugin?.module?.webhook?

  plugin?.module?.webhook plugin.state, req, plugin.emitter, done

module.exports.handleUserAction = (action, user)->
  async.forEach _.values(module.exports.plugins), (plugin, done)->
    return done(null, []) if not plugin?.module?.handleUserAction?
    plugin.module.handleUserAction plugin.state, action, user, plugin.emitter, done

module.exports.run = ()->
  async.forEach _.values(module.exports.plugins), (plugin, done)->
    return done(null, []) if not plugin?.module?.run?
    plugin.module.run plugin.state, plugin.emitter
    done()

buildWebhook = (name)->
  "/plugins/#{name}/webhook"
