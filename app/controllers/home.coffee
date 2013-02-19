{Controller} = require 'spine'
translate = require 't7e'

class Home extends Controller
  constructor: ->
    super
    @html translate h1: 'navigation.home'

module.exports = Home
