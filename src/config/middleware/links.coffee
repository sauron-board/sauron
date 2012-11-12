
# TODO figure out urlFor outside of locomotive
globalLinks = [
  rel: "index", href: "/", prompt: "Index"
]

module.exports = (req, res, next)->
  protocol = req.protocol or "http"
  host = req.get "host"

  res.locals.globalLinks = []
  next()
