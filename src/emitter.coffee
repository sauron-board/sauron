
io = require "socket.io"
registry = require "./lib/registry"

module.exports = (app, fn)->
  io = io.listen app.server

  # TODO emit the logged in user
  io.sockets.on "connection", (socket)->
    registry.handleUserAction "connection", {}
    socket.on "disconnect", ()->
      registry.handleUserAction "disconnect", {}

  emitter =
    emit: (href, item, collection, done=()->)->
      # Send out the publish event
      io.sockets.emit "publish", rel: collection, itemURL: href
      done()

    retract: (href, collection, done=()->)->
      io.sockets.emit "retract", rel: collection, itemURL: href
      done()

  fn null, emitter
