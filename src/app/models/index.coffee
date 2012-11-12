
db = require "../../lib/db"

module.exports.Publication = db.define "Publication", {
  pub_id: String
  data: String
  collection: String
  date: type: Date, default: Date.now
}