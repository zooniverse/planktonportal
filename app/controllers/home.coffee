Page = require './page'
template = require '../views/home'
Counter = require './counter'

class Home extends Page
  className: 'home'

  elements:
    '.home-page-critter': 'critter'

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

module.exports = Home
