module.exports = (req, res, next)->
  errorObj =
    code: 404
    title: "Not found"

  locals =
    error: errorObj
    user: req.user
    href: req.fullUrl

  format = req.accepts ['html', 'json']
  ext = if format is "json" then "cscj" else "ejs"

  res.render "error.#{ext}", locals, (renderError, result)->
    console.error renderError if renderError
    # Let's hope the error template has no error
    res.send 404, result
