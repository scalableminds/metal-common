_    = require("lodash")
path = require("path")

module.exports = rewritePostFilenames = (pattern) ->

  (files, m, done) ->

    adding = {}
    _.each(files, (file, filename) ->
      if file.slug
        delete files[filename]
        filename = filename.replace(/^(.*)\/([^\/]+)(\.[^\/]+)$/, (fullMatch, dirname, basename, extname) ->
          fileObj =
            dirname : dirname
            extname : extname
            basename : basename
          pattern(fileObj, file)
          return path.join(fileObj.dirname, "#{fileObj.basename}#{fileObj.extname}")
        )
        adding[filename] = file
    )

    _.extend(files, adding)

    done()