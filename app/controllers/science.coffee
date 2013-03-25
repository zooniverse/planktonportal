{Stack} = require 'spine/lib/manager'
Page = require './page'
translate = require 't7e'

class Science extends Stack
  className: "science #{Stack::className}"

  controllers:
    about: class extends Page then content: translate {div: 'science.about'}
    explore: class extends Page then content: 'EXPLORE'
    search: class extends Page then content: 'SEARCH'

  navLinks:
    about: translate {span: 'navigation.aboutPages.about'}
    explore: translate {span: 'navigation.aboutPages.explore'}
    search: translate {span: 'navigation.aboutPages.search'}

  routes:
    '/science/about': 'about'
    '/science/explore': 'explore'
    '/science/search': 'search'

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
