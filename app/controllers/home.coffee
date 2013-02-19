{Controller} = require 'spine'
template = require '../views/home'

class Home extends Controller
  className: 'home'

  elements:
    '.critter': 'critter'

  constructor: ->
    super
    @html template
    @critter.prependTo document.body

  activate: ->
    super
    setTimeout => @critter.addClass 'active'

  deactivate: ->
    super
    setTimeout => @critter.removeClass 'active'

module.exports = Home
