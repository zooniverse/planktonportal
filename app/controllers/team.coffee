Page = require './page'

template = require '../views/team'

class Team extends Page
  className: "team"
  content: template

module.exports = Team
