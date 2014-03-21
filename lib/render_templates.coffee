_           = require("lodash")
async       = require("async")
frontMatter = require("front-matter")
vinylfs     = require("vinyl-fs")

module.exports = renderTemplates = (partialsDirectory, layoutsDirectory, locals) ->

  commonLocals = _.extend({}, locals)

  templatize = (str) ->

    if not _.isString(str)
      str = str.toString()

    return _.template("""
      <%
        var __partial = obj.partial, __contents = obj.contents;
        partial = function (name, locals) { return __partial(name, _.extend({}, obj, locals)) };
        contents = function (locals) { return __contents(_.extend({}, obj, locals)) };
      %>#{str}
    """)

  (files, m, done) ->

    async.waterfall([

      (callback) ->

        loadIntoCache = (directory) ->

          (callback) ->

            cache = {}
            vinylfs.src(directory)
              .on("data", (vinylFile) ->

                { attributes, body } = frontMatter(vinylFile.contents.toString())
                file = attributes
                file.contents = new Buffer(body)
                file.renderer = templatize(body)

                cache[vinylFile.relative] = file
              )
              .on("end", ->
                callback(null, cache)
              )
            return


        async.parallel(
          partials : loadIntoCache(partialsDirectory)
          layouts  : loadIntoCache(layoutsDirectory)
          callback
        )


      (cache, callback) ->

        commonLocals.partial = (name, locals) ->
          return cache.partials[name].renderer(locals)

        _.each(files, (file, filename) ->
          file.renderer = templatize(file.contents)
          file.url = "/" + filename.replace(/index\.html$/, "")
          return
        )

        posts = _.filter(files, isPost : true)
        posts = _.sortBy(posts, (file) -> -file.date.valueOf())

        _.each(files, (file, filename) ->

          renderChain = [file.renderer]

          current = file
          while current.layout

            if not cache.layouts[current.layout]
              throw new Error("Layout \"#{current.layout}\" not found.")

            current = cache.layouts[current.layout]

            do (current) ->
              nextLayoutRenderer = renderChain[0]
              renderChain.unshift(
                (locals) ->
                  locals = _.extend({}, locals, contents : nextLayoutRenderer)
                  return current.renderer(locals)
              )

          locals = _.extend(
            {}
            {
              file : file
              site : { posts }
              url : file.url
            }
            commonLocals
          )

          file.contents = new Buffer(renderChain[0](locals))
          return
        )

        callback()

    ], done)
