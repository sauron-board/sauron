
{Schema} = require "jugglingdb"

DB_TYPE = process.env.DB_TYPE or "memory"
process.env.DB_OPTIONS = "{}" if not process.env.DB_OPTIONS
DB_OPTIONS = JSON.parse(process.env.DB_OPTIONS) or {}

module.exports = new Schema DB_TYPE, DB_OPTIONS
