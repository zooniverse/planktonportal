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
    console.log "Activating #{@className}"
    HTML.addClass @htmlClassName

    # TODO: Activate the parent stack, if there is one.

  deactivate: ->
    super
    console.log "Deactivating #{@className}"
    HTML.removeClass @htmlClassName


module.exports = Page
