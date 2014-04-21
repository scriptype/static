// Generated by CoffeeScript 1.6.3
var FileSystem, Mkdirp, Page, Utils, fileReady;

FileSystem = require("fs");

Mkdirp = require("mkdirp");

Utils = require("./utils/utils.js");

Page = (function() {
  function Page(options) {
    var categoryPath, fileData, fileName;
    this.pageData = {
      meta: options.meta,
      content: this.parseContent(options.content)
    };
    switch (this.pageData.meta.type) {
      case "post":
        this.pageData.paths = {
          CSS: "../res/css",
          JS: "../res/js",
          IMG: "../res/img"
        };
        categoryPath = "public/" + (Utils.delocalizeString(this.pageData.meta["category"]));
        fileName = Utils.delocalizeString(this.pageData.meta.title);
        fileData = Utils.prepareTemplate("post", this.pageData);
        Mkdirp(categoryPath, function(error) {
          if (error) {
            throw error;
          }
          return FileSystem.writeFile("" + categoryPath + "/" + fileName + ".html", fileData, function(err) {
            if (err) {
              throw err;
            }
            return console.log("" + fileName + " created in " + categoryPath);
          });
        });
        break;
      case "page":
        console.log("LEL");
        break;
      case "index":
        console.log("LOL");
        break;
      default:
        console.log("fuck lan");
    }
  }

  Page.prototype.parseContent = function(content) {
    return "\n" + (content.split("\r\n\r\n").map(function(e) {
      return "\t\t<p>" + (e.replace(/\r\n/g, "<br />\n\t\t")) + "</p>";
    }).join("\n")) + "\n";
  };

  return Page;

})();

fileReady = function(error, data) {
  var content, key, metaData, metaObject, seperatorChars, _data, _i, _key, _len, _m;
  if (error) {
    throw error;
  }
  seperatorChars = "\r\n\r\n\r\n";
  _data = data.split(seperatorChars);
  metaData = _data.shift();
  content = _data.join(seperatorChars);
  metaObject = new Object();
  _m = metaData.split("\r\n");
  for (_i = 0, _len = _m.length; _i < _len; _i++) {
    key = _m[_i];
    _key = key.split("::");
    metaObject[_key[0].replace(/\s/g, "")] = _key[1];
  }
  return new Page({
    meta: metaObject,
    content: content
  });
};

FileSystem.readFile("draft/Hello World.txt", "utf-8", fileReady);

/*
//@ sourceMappingURL=parser.map
*/
