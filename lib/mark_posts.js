var _ = require("lodash");

module.exports = function markPosts(directory) {
  var regex;
  regex = new RegExp("^" + directory);
  return function(files, m, done) {
    _.each(files, function(file, filename) {
      file.isPost = regex.test(filename);
    });
    done();
  };
};
