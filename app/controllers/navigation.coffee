{Controller} = require 'spine'
template = require '../views/navigation'

class Navigation extends Controller
  tag: 'nav'
  className: 'site-navigation'

  constructor: ->
    super
    @el.html template

module.exports = Navigation
