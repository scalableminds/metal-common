exports.renderMarkdown         = require("./lib/render_markdown")
exports.parsePostFilenames     = require("./lib/parse_post_filenames")
exports.rewritePostFilenames   = require("./lib/rewrite_post_filenames")
exports.removeUnderscoredFiles = require("./lib/remove_underscored_files")
exports.markPosts              = require("./lib/mark_posts")
exports.renderTemplates        = require("./lib/render_templates")
exports.gulpBridge              = require("./lib/gulp_bridge")
exports.permalinks             = require("metalsmith-permalinks")

exports.logger = ->

  _ = require("lodash")

  (files, m, done) ->
    for filename, file of files
      console.log(filename, _.omit(file, "contents"))
    return