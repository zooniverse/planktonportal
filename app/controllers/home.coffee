Page = require './page'
template = require '../views/home'
Footer = require 'zooniverse/controllers/footer'

class Home extends Page
  className: 'home'
  content: template

  constructor: ->
    super

    @footer = new Footer
    @el.append @footer.el

  activate: ->
    super
    # TODO: Update the project stats.

module.exports = Home
