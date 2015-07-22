request = require('request')
async = require('async')
inlineCss = require('inline-css')
cheerio = require('cheerio')
makeNote = require('../service/makeNote')
noteStore = require('../service/noteStroe')


url = 'https://gist.github.com/youqingkui/cf1027f737c48bd6207d'

request.get url, (err, res, body) ->
  return console.log err if err

  inlineCss body, {url:'/'}, (err2, html) ->
    return console.log err2 if err2

    $ = cheerio.load(html)
    $codeHtml = $(".blob-wrapper")
    $ = cheerio.load $codeHtml.html()
    $(".js-line-number").each (index, item) ->
      number = item.attribs['data-line-number']
      $(this).text(number)
#    $(".js-line-number").remove()
    $("*").map (i, elem) ->
      for k, v of elem.attribs
        if k != 'style'
          $(this).removeAttr(k)


    changeHtml = $.html()
    console.log(changeHtml)
    makeNote noteStore, 'gist', changeHtml, '', (err, note) ->
      return console.log err if err

      console.log note


      


