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
    setTimeout =>
      HTML.addClass @htmlClassName
      @el.addClass 'activated'

  deactivate: ->
    super
    setTimeout =>
      @el.removeClass 'activated'
      HTML.removeClass @htmlClassName

module.exports = Page
