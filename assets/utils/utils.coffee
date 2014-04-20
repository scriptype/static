FileSystem  = require "fs"
Handlebars  = require "handlebars"
Utils       = null

exports.prepareTemplate = (template, data) ->
  fd = FileSystem.readFileSync "./assets/templates/#{template}.hbs", "utf-8"
  return Handlebars.compile(fd)(data)

exports.delocalizeString = (str) ->
  return str
  .toLocaleLowerCase()
  .replace(/\s/g, "-")
  .replace(/ş/g, "s")
  .replace(/ı/g, "i")
  .replace(/ğ/g, "g")
  .replace(/ü/g, "u")
  .replace(/ö/g, "o")
  .replace(/ç/g, "c")