{Stack} = require 'spine/lib/manager'
Page = require './page'
translate = require 't7e'

teamPageTemplate = require '../views/teams'

class About extends Stack
  className: "about #{Stack::className}"

  controllers:
    learn: class extends Page then content: 'LEARN'
    explore: class extends Page then content: 'EXPLORE'
    search: class extends Page then content: 'SEARCH'
    teams: class extends Page then content: teamPageTemplate

  navLinks:
    learn: translate {span: 'navigation.aboutPages.learn'}
    explore: translate {span: 'navigation.aboutPages.explore'}
    search: translate {span: 'navigation.aboutPages.search'}
    teams: translate {span: 'navigation.aboutPages.teams'}

  routes:
    '/about/learn': 'learn'
    '/about/explore': 'explore'
    '/about/search': 'search'
    '/about/teams': 'teams'

  default: 'learn'

  constructor: ->
    super

    nav = $('<nav></nav>')

    reverseRoutes = {}
    reverseRoutes[controller] = route for route, controller of @routes

    for controller, text of @navLinks
      nav.append "<a href='##{reverseRoutes[controller]}'>#{text}</a>"

    @el.prepend nav

module.exports = About
