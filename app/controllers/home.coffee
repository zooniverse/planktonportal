Page = require './page'
template = require '../views/home'
Counter = require './counter'
Footer = require 'zooniverse/controllers/footer'

class Home extends Page
  className: 'home'

  diveCounter: null
  speedCounter: null
  classificationsCounter: null
  footer: null

  elements:
    '.home-page-critter': 'critter'

  constructor: ->
    super
    @html template
    @critter.prependTo document.body

    @diveCounter = new Counter el: @el.find '.dive.counter'
    @speedCounter = new Counter el: @el.find '.speed.counter'
    @classificationsCounter = new Counter el: @el.find '.classifications.counter'

    @footer = new Footer
    @el.append @footer.el

  activate: ->
    super
    # TODO: Update the project stats.
    @diveCounter.set Math.floor Math.random() * 1000
    @speedCounter.set Math.floor Math.random() * 1000
    @classificationsCounter.set Math.floor Math.random() * 1000

module.exports = Home
