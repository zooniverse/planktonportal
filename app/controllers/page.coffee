$ = window.jQuery
{Controller} = require 'spine'

HTML = $(document.body).parent()

class Page extends Controller
  className: 'generic'
  content: ''

  htmlClassName: ''

  constructor: ->
    super
    @htmlClassName ||= "on-#{@className}-page"

    @html @content

  activate: ->
    super
    # console.log "Activating #{@className}"
    HTML.addClass @htmlClassName

    @stack.stack?.manager?.change @stack

  deactivate: ->
    super
    # console.log "Deactivating #{@className}"
    HTML.removeClass @htmlClassName

module.exports = Page
