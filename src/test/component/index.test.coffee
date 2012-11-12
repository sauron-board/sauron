request = require "supertest"
should = require "should"
process.env.NODE_ENV = "development"
app = null

describe "Index", ->

  before (done)->
    require("../../server") (err, _app)->
      throw err if err
      app = _app
      done()

  describe "GET /", ->

    it "should work"
