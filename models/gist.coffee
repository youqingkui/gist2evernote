mongoose = require('./mongoose')

gistsSchema = mongoose.Schema
  gitst_id:{type:String, unique: true}
  files:Array
  created_at:String
  updated_at:String
  description:String
  html_url:String
  html_content:String


module.exports = mongoose.model('Gist', gistsSchema)