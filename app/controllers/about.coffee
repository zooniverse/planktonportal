Page = require './page'
translate = require 't7e'

class About extends Page
  className: 'about'

  constructor: ->
    super
    @html translate h1: 'navigation.about'

module.exports = About
