module.exports = (req, res, next) ->
  protocol = if req.header("X-Forwarded-Protocol") then "https" else "http"
  host = req.header("host")

  req.fullUrl = "#{protocol}://#{host}#{req.url}"
  next()