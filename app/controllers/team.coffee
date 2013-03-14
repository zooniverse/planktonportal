Page = require './page'

template = require '../views/team'

class Team extends Page
  className: "team #{Page::className}"
  content: template

module.exports = Team
