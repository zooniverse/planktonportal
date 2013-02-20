{Controller} = require 'spine'
template = require '../views/home'
Counter = require './counter'

class Home extends Controller
  className: 'home'

  elements:
    '.critter': 'critter'

  constructor: ->
    super
    @html template
    @critter.prependTo document.body

    @diveCounter = new Counter el: @el.find '.dive.counter'
    @speedCounter = new Counter el: @el.find '.speed.counter'
    @classificationsCounter = new Counter el: @el.find '.classifications.counter'

  activate: ->
    super
    # TODO: Update the project stats.
    @diveCounter.set Math.floor Math.random() * 1000
    @speedCounter.set Math.floor Math.random() * 1000
    @classificationsCounter.set Math.floor Math.random() * 1000
    setTimeout => @critter.addClass 'active'

  deactivate: ->
    super
    setTimeout => @critter.removeClass 'active'

module.exports = Home
