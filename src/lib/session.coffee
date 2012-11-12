db = require "./db"
Store = require("connect").session.Store

Session = db.define "Session", {
  sessionID: String
  data: String
}


###
Initialize SessionStore with the given `options`.
###
JUGGLINGDBSTORE = module.exports = (options, callback=()->) ->
  callback()


JUGGLINGDBSTORE::__proto__ = Store::

###
Attempt to fetch session by the given `sid`.
###
JUGGLINGDBSTORE::get = (sid, cb=()->) ->
  Session.findOne {where: {sessionID: sid}}, (err, session)->
    console.log err
    data = null
    data = JSON.parse session?.data if session?
    console.log sid, data
    cb null, data

###
Commit the given `sess` object associated with the given `sid`.
###
JUGGLINGDBSTORE::set = (sid, sess, cb=()->) ->
  Session.findOne {where: {sessionID: sid}}, (err, session)->
    session = new Session if not session
    session.sessionID = sid
    session.data = JSON.stringify sess
    session.save cb

###
Destroy the session associated with the given `sid`.
###
JUGGLINGDBSTORE::destroy = (sid, cb=()->) ->
  Session.findOne {where: {sessionID: sid}}, (err, session)->
    return session.destroy(cb) if session
    cb()


###
Fetch number of sessions.
###
JUGGLINGDBSTORE::length = (cb=()->) ->
  Session.count cb


###
Clear all sessions.

@param {Function} cb
@api public
###
JUGGLINGDBSTORE::clear = (cb=()->) ->
  Session.destroyAll cb
