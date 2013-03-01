{Stack} = require 'spine/lib/manager'
Page = require './page'

teamPageTemplate = require '../views/teams'

class About extends Stack
  className: "about #{Stack::className}"

  controllers:
    learn: class extends Page then content: 'LEARN'
    explore: class extends Page then content: 'EXPLORE'
    search: class extends Page then content: 'SEARCH'
    teams: class extends Page then content: teamPageTemplate

  routes:
    '/about/learn': 'learn'
    '/about/explore': 'explore'
    '/about/search': 'search'
    '/about/teams': 'teams'

  default: 'learn'

module.exports = About
