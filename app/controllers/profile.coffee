{Controller} = require 'spine'
translate = require 'translate'

class Profile extends Controller
  constructor: ->
    super
    @html translate h1: 'navigation.profile'

module.exports = Profile
