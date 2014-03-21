_      = require("lodash")
moment = require("moment")

module.exports = parsePostFilenames = ->

  (files, m, done) ->
    _.each(files, (file, filename) ->
      parts = filename.match(/\/(\d{4}\-\d{2}\-\d{2})-(.*)\..+$/)
      if parts
        [a, date, slug] = parts
        file = files[filename]
        file.date = moment(date)
        file.slug = slug
    )
    done()