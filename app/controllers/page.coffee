$ = window.jQuery
{Controller} = require 'spine'

HTML = $(document.body).parent()

class Page extends Controller
  className: 'generic'
  htmlClassName: ''

  constructor: ->
    super
    @htmlClassName ||= "on-#{@className}-page"

  activate: ->
    super
    console.log "Activating #{@className}"
    HTML.addClass @htmlClassName

  deactivate: ->
    super
    console.log "Deactivating #{@className}"
    HTML.removeClass @htmlClassName


module.exports = Page
