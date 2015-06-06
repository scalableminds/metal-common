_           = require("lodash")
metalsmith  = require("metalsmith")
frontMatter = require("front-matter")
utf8        = require("is-utf8")
File        = require("gulp-util").File
through     = require("through2")


module.exports = gulpBridge = (func) ->

  files = {}

  through.obj(

    (vinyl, enc, done) ->

      if vinyl.isStream()
        done(new Error("Streaming is not supported."))
        return

      if vinyl.isNull()
        done()
        return
        
      # make path separators consistent
      filename = vinyl.relative.replace(/\\/g, "/")

      if utf8(vinyl.contents)
        { attributes, body } = frontMatter(vinyl.contents.toString())
        files[filename] = attributes
        files[filename].contents = new Buffer(body)

      else
        files[filename] =
          contents : vinyl.contents

      done()
      return


    (done) ->

      metal = metalsmith(__dirname)
      func(metal)

      metal.run(files, (err, files) =>

        if err
          done(err)

        else
          _.each(files, (file, filename) =>
            @push(new File(
              path : filename
              contents : file.contents
            ))
          )
          done()
      )
      return
  )
