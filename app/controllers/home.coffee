{Controller} = require 'spine'
translate = require 'translate'

class Home extends Controller
  constructor: ->
    super
    @html translate h1: 'navigation.home'

module.exports = Home
