vinylfs    = require("vinyl-fs")
async      = require("async")

exports.register = (metalsmith) ->

  metalsmith::toVinylStream = ->

    _        = require("lodash")
    File     = require("gulp-util").File
    Readable = require("stream").Readable

    outputStream = new Readable(objectMode : true)
    outputStream._read = ->

    @run((err, files) ->
      if err
        outputStream.emit("error", err)
      else
        _.each(files, (file, filename) ->
          outputStream.push(new File(
            path : filename
            contents : file.contents
          ))
        )
        outputStream.push(null)
    )

    return outputStream