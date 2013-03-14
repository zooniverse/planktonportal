{Stack} = require 'spine/lib/manager'
Page = require './page'
translate = require 't7e'

class Science extends Stack
  className: "science #{Stack::className}"

  controllers:
    learn: class extends Page then content: 'LEARN'
    explore: class extends Page then content: 'EXPLORE'
    search: class extends Page then content: 'SEARCH'

  navLinks:
    learn: translate {span: 'navigation.aboutPages.learn'}
    explore: translate {span: 'navigation.aboutPages.explore'}
    search: translate {span: 'navigation.aboutPages.search'}

  routes:
    '/about/learn': 'learn'
    '/about/explore': 'explore'
    '/about/search': 'search'

  default: 'learn'

  constructor: ->
    super

    nav = $('<nav></nav>')

    reverseRoutes = {}
    reverseRoutes[controller] = route for route, controller of @routes

    for controller, text of @navLinks
      nav.append "<a href='##{reverseRoutes[controller]}'>#{text}</a>"

    @el.prepend nav

module.exports = Science
