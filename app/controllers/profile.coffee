Page = require './page'
translate = require 't7e'

class Profile extends Page
  className: 'profile'
  content: (translate h1: 'navigation.profile')

module.exports = Profile
