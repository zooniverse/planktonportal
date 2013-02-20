{Controller} = require 'spine'

class About extends Controller
  className: 'about'

  constructor: ->
    super
    @html 'About'

module.exports = About
