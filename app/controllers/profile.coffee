Page = require './page'
translate = require 't7e'

class Profile extends Page
  className: 'profile'

  constructor: ->
    super
    @html translate h1: 'navigation.profile'

module.exports = Profile
