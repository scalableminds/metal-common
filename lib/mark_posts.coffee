_ = require("lodash")

module.exports = markPosts = (directory) ->

  regex = new RegExp("^#{directory}")

  (files, m, done) ->

    _.each(files, (file, filename) ->
      file.isPost = regex.test(filename)
      return
    )

    done()