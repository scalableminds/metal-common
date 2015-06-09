// Generated by CoffeeScript 1.9.2
var _, moment;

_ = require("lodash");
moment = require("moment");

module.exports = function parsePostFilenames() {
  return function(files, m, done) {
    _.each(files, function(file, filename) {
      var a, date, parts, slug;
      parts = filename.match(/\/(\d{4}\-\d{2}\-\d{2})-(.*)\..+$/);
      if (parts) {
        a = parts[0], date = parts[1], slug = parts[2];
        file = files[filename];
        file.date = moment(date);
        return file.slug = slug;
      }
    });
    done();
  };
};