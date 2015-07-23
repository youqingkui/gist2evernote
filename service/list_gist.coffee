async = require('async')
Gists = require('../models/gist')
request = require('request')
inlineCss = require('inline-css')
cheerio = require('cheerio')
makeNote = require('../service/makeNote')
noteStore = require('../service/noteStroe')

class ListGist
  constructor: () ->
    @url = "https://api.github.com/users/youqingkui/gists"

    @headers = {
      'User-Agent':'youqingkui-gist2evernote'
    }

  getGist: (cb) ->
    self = @
    op = {
      url:self.url
      headers:self.headers
    }
    request.get op, (err, res, body) ->
      return cb(err) if err

      cb(null, body)


  findGist: (gistID, cb) ->
    Gists.findOne {gist_id:gistID}, (err, row) ->
      return cb(err) if err

      if row
        return cb()

      return cb(null, row)

  getGistHtml:(htmlUrl, cb) ->
    self = @
    async.waterfall [
      (callback) ->
        op = self.genHeaders(htmlUrl)
        request.get op, (err, res, body) ->
          return console.log err if err
          callback(null, body)

      (body, callback) ->
        inlineCss body, {url:'/'}, (err, html) ->
          return console.log err if err
          callback(null, html)

      (body, callback) ->
        $ = cheerio.load(body)
        $codeHtml = $(".blob-wrapper")
        if $codeHtml.length is 0
          return callback("没有发现代码块【%s】", body)

        $ = cheerio.load $codeHtml.html()
        $(".js-line-number").remove()
        $("*").map (i, elem) ->
          for k, v of elem.attribs
            if k != 'style'
              $(this).removeAttr(k)

        changeHtml = $.html()
        cb(null, changeHtml)
    ]

  genHeaders: (url, headers) ->
    defHed = {
      'User-Agent':'youqingkui-gist2evernote'
    }
    if headers
      defHed = headers

    op = {
      url:url
      headers:defHed
    }
    return op


  pushEvernote: (html, gistInfo, cb) ->
    guid = '9fad7bbe-9b7d-40f4-a7d9-78ae99a5730e'
    makeNote noteStore, gistInfo.description, html, guid, (err, note) ->
      return console.log err if err
      cb(null, note)


  saveGist: (gistInfo, cb) ->
    self = @
    async.waterfall [
      (callback) ->
        self.getGistHtml gistInfo.html_url, (err, html) ->
          return console.log err if err

          callback(null, html)

      (html, callback) ->
        self.pushEvernote html, gistInfo, (err, note) ->
          return console.log err if err
          callback(null, note, html)

      (note, html, callback) ->
        gist = Gists()
        gist.id = gistInfo.id
        gist.html_url = gistInfo.html_url
        gist.created_at = gistInfo.created_at
        gist.updated_at = gistInfo.updated_at
        gist.description = gistInfo.description
        gist.files = []
        for k, v of gistInfo.files
          gist.files.push v
        gist.html_content = html
        gist.save (err, row) ->
          return console.log err if err

          
    ]










l = new ListGist()
l.getGist (err, data) ->
  data = JSON.parse data
#  console.log data

  l.saveGist(data[0])


