// Generated by CoffeeScript 1.9.2
var highlight, markdown, marked;

markdown = require("metalsmith-markdown");
marked = require("marked");
highlight = require("highlight.js").highlight;

module.exports = function renderMarkdown() {
  var markedRenderer;
  markedRenderer = new marked.Renderer();
  markedRenderer.code = function(code, lang) {
    if (lang) {
      return "<pre><code class=\"" + lang + "\">" + (highlight(lang, code).value) + "</code></pre>";
    } else {
      return "<pre><code>" + code + "</code></pre>";
    }
  };
  return markdown({
    smartypants: true,
    renderer: markedRenderer
  });
};
