{Controller} = require 'spine'
translate = require 't7e'

class Classify extends Controller
  constructor: ->
    super
    @html translate h1: 'navigation.classify'

module.exports = Classify
