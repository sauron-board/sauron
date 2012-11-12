express = require "express"
passport = require "passport"
module.exports = ->
  
  @disable "x-powered-by"

  @set "views", "#{__dirname}/../../app/views"
  @set "view engine", "ejs"
  
  @engine "cscj", require("cscj").__express
  @engine "ejs", require("ejs").__express
  
  this.format "json", engine: "cscj"
  this.format "html", engine: "ejs"

  isDev = @get("env") is "development"

  locals = @_routes._http.locals

  assetsConfig =
    src: "#{__dirname}/../../assets"
    helperContext: locals
    buildDir: "#{__dirname}/../../.cache"
  @use require("connect-assets") assetsConfig
  locals.css.root = "stylesheets"
  locals.js.root = "javascripts"
  locals.img.root = "images"

  @use "/components", express.static "#{__dirname}/../../components"
  @use "/img", express.static "#{__dirname}/../../components/bootstrap.css/img"

  @use express.timeout()
  @use require "../middleware/fullUrl"
  @use express.favicon()
  @use express.logger(if isDev then "dev")
  @use express.responseTime()
  @use express.bodyParser()
  @use express.methodOverride()
  @use express.cookieParser()
  @use express.session (
    secret: process.env.SESSION_SECRET or "sauron-secret"
    store: new (require "../../lib/session")
  )
  @use passport.initialize()
  @use passport.session()
  @use require "../middleware/auth"
  @use require "../middleware/experiment"
  @use require "../middleware/links"
  @use @router
  @use require "../middleware/404"
  @use require "../middleware/error"
