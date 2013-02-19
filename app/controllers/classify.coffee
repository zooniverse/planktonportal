{Controller} = require 'spine'
translate = require 'translate'

class Classify extends Controller
  constructor: ->
    super
    @html translate h1: 'navigation.classify'

module.exports = Classify
