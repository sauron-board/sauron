module.exports = (error, req, res, next)->

  status = error.status or 500
  console.error error if status >= 500

  errorObj =
    code: status
    title: error.message
    message: error.stack

  locals =
    error: errorObj
    user: req.user
    href: req.fullUrl

  format = req.accepts ['html', 'json']
  ext = if format is "json" then "cscj" else "ejs"

  res.render "error.#{ext}", locals, (renderError, result)->
    # Let's hope the error template has no error
    res.send status, result
