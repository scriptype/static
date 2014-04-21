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
    return content.split("\r\n\r\n").map( (e) ->
      return "<p>#{e.replace(/\r\n/g, "<br />\n")}</p>"
    ).join("\n")


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


FileSystem.readFile "draft.txt", "utf-8", fileReady