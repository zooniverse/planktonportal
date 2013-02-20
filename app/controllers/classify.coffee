Page = require './page'
translate = require 't7e'
class Classify extends Page
  className: 'classify'

  constructor: ->
    super
    @html translate h1: 'navigation.classify'

module.exports = Classify
