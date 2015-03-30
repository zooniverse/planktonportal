{Stack} = require 'spine/lib/manager'
Page = require './page'
translate = require 't7e'
FieldGuide = require './field-guide'
Team = require './team'
speciesTemplate = require '../views/species'

class Science extends Stack
  className: "science #{Stack::className}"

  controllers:
    fieldGuide: FieldGuide
    about: class extends Page then content: translate 'div', 'science.about.content'
    education: class extends Page then content: translate 'div', 'education.content'
    whyStudy: class extends Page then content: translate 'div', 'science.whyStudy.content'
    images: class extends Page then content: translate 'div', 'science.images.content'
    team: Team

  navLinks:
    about: translate 'span', 'science.about.title'
    fieldGuide: translate 'span', 'science.fieldGuide.title'
    education: translate 'span', 'education.title'
    whyStudy: translate 'span', 'science.whyStudy.title'
    images: translate 'span', 'science.images.title'
    team: translate 'span', 'about.title'

  routes:
    '/science': 'about'
    '/science/field-guide': 'fieldGuide'
    '/science/education': 'education'
    '/science/why-study': 'whyStudy'
    '/science/images': 'images'
    '/science/team': 'team'

  default: 'about'

  constructor: ->
    super

    nav = $('<nav></nav>')

    reverseRoutes = {}
    reverseRoutes[controller] = route for route, controller of @routes

    for controller, text of @navLinks
      nav.append "<a href='##{reverseRoutes[controller]}'>#{text}</a>"

    @el.prepend nav

module.exports = Science
