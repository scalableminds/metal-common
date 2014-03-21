_ = require("lodash")

module.exports = removeUnderscoredFiles = ->

  (files, m, done) ->

    _.each(files, (file, filename) ->
      if _.any(filename.split("/"), (part) -> /^\_/.test(part))
        delete files[filename]
    )

    done()