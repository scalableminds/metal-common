markdown   = require("metalsmith-markdown")
marked     = require("marked")
highlight  = require("highlight.js").highlight


module.exports = renderMarkdown = ->

  markedRenderer = new (marked.Renderer)()
  markedRenderer.code = (code, lang) ->
    if lang
      """
      <pre><code class="#{lang}">#{highlight(lang, code).value}</code></pre>
      """
    else
      """
      <pre><code>#{code}</code></pre>
      """

  markdown(
    smartypants : true
    renderer : markedRenderer
  )