App = require ".."
_ = require "underscore"
async = require "async"
fs = require "fs"
path = require "path"
# creator = "../sauron/creator"
optparse = require "optparse"

switches = [
  # [ "-c", "--create PATH",     "Create a deployable sauron" ],
  [ "-h", "--help",            "Display the help information" ],
  [ "-n", "--name NAME",       "The name of the app" ],
  [ "-v", "--version",         "Displays the version of sauron installed" ]
]

options =
  create: false
  name: "Sauron"
  path: "."

parser = new optparse.OptionParser switches
parser.banner = "Usage sauron [options]"

parser.on "create", (opt, value)->
  options.path = value
  options.create = true

parser.on "help", (opt, value)->
  console.log parser.toString()
  process.exit 0

parser.on "name", (opt, value)->
  options.name = value

parser.on "version", (opt, value)->
  options.version = true

parser.parse process.argv

unless process.platform is "win32"
  process.on 'SIGTERM', ->
    process.exit 0

if options.create
  creator = new Create options.path
  creator.run()
else
  app = new App options.name
  app.init (err)->
    if options.version
      console.log app.version
      process.exit 0

    plugins = require "#{process.cwd()}/plugins"

    async.forEach _.keys(plugins), ((name, next)->
      plugin = plugins[name]
      module = undefined

      try
        # ./plugins
        module = require "#{process.cwd()}/plugins/#{plugin.package}"
      catch e
        throw e if e.code isnt "MODULE_NOT_FOUND"
        try
          # node_modules
          module = require plugin.package
        catch e
          throw e if e.code isnt "MODULE_NOT_FOUND"
          [pkg, file] = plugin.package.split('/')
          if pkg? and file?
            try
              module = require(pkg)[file]
            catch e
              console.log e
              throw e if e.code isnt "MODULE_NOT_FOUND"

          if not module?
            try
              # built-in plugins
              module = require "#{__dirname}/../plugins/#{plugin.package}"
            catch e
              throw e if e.code isnt "MODULE_NOT_FOUND"
              error = new Error "A problem occured trying to load '#{plugin.package}'"
              return next error
      app.load name, module, plugin, plugin.config, next
    ), (err)->
      if err
        console.error err
        process.exit 1

      app.run()
