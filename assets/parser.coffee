FileSystem  = require "fs"
Mkdirp      = require "mkdirp"
Utils       = require "./utils/utils.js"

class Page

  constructor: (options) ->
    @pageData =
      meta: options.meta
      content: @parseContent options.content

    switch @pageData.meta.type
      when "post"
        @pageData.paths =
          CSS : "../res/css"
          JS  : "../res/js"
          IMG : "../res/img"
        categoryPath  = "public/#{Utils.delocalizeString(@pageData.meta["category"])}"
        fileName      = Utils.delocalizeString(@pageData.meta.title)
        fileData      = Utils.prepareTemplate "post", @pageData
        Mkdirp categoryPath, (error) ->
          throw error if error
          FileSystem.writeFile "#{categoryPath}/#{fileName}.html", fileData, (err) ->
            throw err if err
            console.log "#{fileName} created in #{categoryPath}"

      when "page"
        console.log "LEL"

      when "index"
        console.log "LOL"

      else
        console.log "fuck lan"

  parseContent: (content) ->
    return "\n#{content.split("\r\n\r\n").map (e) ->
      return "\t\t<p>#{e.replace(/\r\n/g, "<br />\n\t\t")}</p>"
    .join("\n")}\n"


fileReady = (error, data) ->
  throw error if error
  seperatorChars = "\r\n\r\n\r\n"
  _data = data.split seperatorChars
  metaData = _data.shift()
  content  = _data.join seperatorChars

  metaObject = new Object()
  _m = metaData.split("\r\n")
  for key in _m
    _key = key.split("::")
    metaObject[_key[0].replace(/\s/g, "")] = _key[1]

  return new Page
    meta: metaObject,
    content: content


pathArg = process.argv[2]
unless pathArg
  return console.log "You need to specify a path or filename, sucker."

draftsFolder = "drafts"

if pathArg is "-a" or pathArg is "-all"
  fileList = FileSystem.readdirSync draftsFolder, (err, dd) ->
    throw err if err
    return dd
  for key in fileList
    FileSystem.readFile "#{draftsFolder}/#{key}", "utf-8", fileReady
else
  FileSystem.readFile "#{draftsFolder}/#{pathArg}", "utf-8", fileReady