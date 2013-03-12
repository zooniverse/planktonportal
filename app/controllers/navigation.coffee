{Controller} = require 'spine'
template = require '../views/navigation'

class Navigation extends Controller
  tag: 'nav'
  className: 'site-navigation'

  @minHeight: 0
  @maxHeight: Infinity

  constructor: ->
    super
    @el.html template

  #   $(window).on 'scroll', => @onScroll arguments...

  #   # Setup should fire after the element has been placed in the DOM.
  #   setTimeout => @setup()

  # setup: ->
  #   @el.css height: 0
  #   @minHeight = @el.height()

  #   @el.css height: 9999
  #   @maxHeight = @el.height()

  #   @el.css height: ''

  #   @onScroll()

  # onScroll: ->
  #   scrolled = scrollY / scrollMaxY

  #   @el.css height: @minHeight + ((1 - scrolled) * (@maxHeight - @minHeight))

  #   console.log @el.height(), {@minHeight, @maxHeight}

module.exports = Navigation
