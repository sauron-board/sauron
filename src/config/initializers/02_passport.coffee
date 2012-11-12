passport = require "passport"
{Strategy} = require "passport-github"

registry = require "../../lib/registry"

module.exports = ->
  passport.use new Strategy(
    clientID: process.env.GITHUB_CLIENT_ID
    clientSecret: process.env.GITHUB_CLIENT_SECRET
    callbackURL: "http://#{process.env.HOST}/auth/github/callback"
  ,
    (accessToken, refreshToken, profile, done) ->
      registry.handleUserAction "login", profile
      done null, profile
  )

  @get "/login", passport.authenticate "github"

  @get "/auth/github/callback",
    passport.authenticate "github",
      successRedirect: "/"
      failureRedirect: "/"

  @get "/logout", (req, res)->
    registry.handleUserAction "logout", req.user
    req.logOut()
    res.redirect "/"

passport.serializeUser (user, done)->
  done null, user

passport.deserializeUser (obj, done)->
  done null, obj
