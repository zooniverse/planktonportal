require './lib/setup'

Navigation = require './controllers/navigation'
navigation = new Navigation
navigation.el.appendTo document.body

# Critter = require './controllers/critter'
# critters =
#   home: 'octopus'

# for pageClass, imageBase of critters
#   critter = new Critter
#     className: pageClass
#     image: "./images/critters/#{imageBase}.jpg"

#   critter.el.appendTo document.body

{Stack} = require 'spine/lib/manager'
Home = require './controllers/home'
Science = require './controllers/science'
Classify = require './controllers/classify'
Profile = require './controllers/profile'
Team = require './controllers/team'

stack = new Stack
  controllers:
    home: Home
    science: Science
    classify: Classify
    profile: Profile
    team: Team

  routes:
    '/': 'home'
    '/science/*': 'science'
    '/classify': 'classify'
    '/profile': 'profile'
    '/team': 'team'

  default: 'home'

stack.el.appendTo document.body

Route = require 'spine/lib/route'
Route.setup()

activeHashLinks = require 'zooniverse/util/active-hash-links'
activeHashLinks.init()

Api = require 'zooniverse/lib/api'
api = new Api project: 'planet_four' #, host: 'BAD_HOST', loadTimeout: 0

TopBar = require 'zooniverse/controllers/top-bar'
topBar = new TopBar
topBar.el.appendTo document.body

User = require 'zooniverse/models/user'
User.fetch()

window.app = {stack, api, topBar}
module.exports = window.app
