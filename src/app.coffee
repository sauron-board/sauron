locomotive = require "locomotive"
http = require "http"
installEmitter = require "./emitter"

path = __dirname
env = process.env.NODE_ENV or "production"
options = {"coffeeScript": true}

process.env.PORT ?= 3000
process.env.HOST ?= require("os").hostname()

console.log "HOST:", process.env.HOST
console.log "PORT:", process.env.PORT

module.exports = class App
  constructor: (@name) ->
    @registry = require "./lib/registry"

  init: (done)->
    self = @
    locomotive.boot path, env, options, (err, server)->
      self.server = http.createServer server
      installEmitter self, (err, emitter)->
        self.emitter = emitter
        done err

  load: (name, plugin, options, config, next)->
    @registry.load name, plugin, options, config, @emitter, next

  run: ()->
    registry = @registry
    @server.listen process.env.PORT, "0.0.0.0", ()->
      addr = @address()
      console.log("listening on %s:%d", addr.address, addr.port)
      registry.run()
