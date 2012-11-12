errs = require "errs"
passport = require "passport"

module.exports = (req, res, next)->
  # Login with GitHub
  next()