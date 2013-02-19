{Controller} = require 'spine'
translate = require 't7e'

class Profile extends Controller
  constructor: ->
    super
    @html translate h1: 'navigation.profile'

module.exports = Profile
