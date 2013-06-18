Page = require './page'
# ImageStack = require 'image-stack'
template = require '../views/field-guide'

class FieldGuide extends Page
  content: template

  constructor: ->
    super
    # ImageStack.parse @el.get 0

module.exports = FieldGuide
