Page = require './page'
template = require '../views/about'

class About extends Page
  className: 'about'

  constructor: ->
    super
    @html template

module.exports = About
