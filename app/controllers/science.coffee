{Stack} = require 'spine/lib/manager'
Page = require './page'
translate = require 't7e'
speciesTemplate = require '../views/species'

class Science extends Stack
  className: "science #{Stack::className}"

  controllers:
    about: class extends Page then content: translate 'div', 'science.about.content'
    whyStudy: class extends Page then content: translate 'div', 'science.whyStudy.content'
    images: class extends Page then content: translate 'div', 'science.images.content'
    species: class extends Page then content: speciesTemplate

  navLinks:
    about: translate 'span', 'science.about.title'
    whyStudy: translate 'span', 'science.whyStudy.title'
    images: translate 'span', 'science.images.title'
    species: translate 'span', 'science.species.title'

  routes:
    '/science/about': 'about'
    '/science/whyStudy': 'whyStudy'
    '/science/images': 'images'
    '/science/species': 'species'

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
