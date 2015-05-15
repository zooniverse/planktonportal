Page = require './page'
template = require '../views/field-guide'

class FieldGuide extends Page
  content: template

  constructor: ->
    super

module.exports = FieldGuide
