require './lib/setup'

Navigation = require './controllers/navigation'

Critter = require './controllers/critter'

{Stack} = require 'spine/lib/manager'
Home = require './controllers/home'
About = require './controllers/about'
Classify = require './controllers/classify'
Profile = require './controllers/profile'
Route = require 'spine/lib/route'

Api = require 'zooniverse/lib/api'
TopBar = require 'zooniverse/controllers/top-bar'
User = require 'zooniverse/models/user'

navigation = new Navigation
navigation.el.appendTo document.body

critters =
  home: 'octopus'

for pageClass, imageBase of critters
  critter = new Critter
    className: pageClass
    image: "./images/critters/#{imageBase}.jpg"

  critter.el.appendTo document.body

stack = new Stack
  controllers:
    home: Home
    about: About
    classify: Classify
    profile: Profile

  routes:
    '/': 'home'
    '/about/*': 'about'
    '/classify': 'classify'
    '/profile': 'profile'

  default: 'home'

stack.el.appendTo document.body

Route.setup()

api = new Api project: 'planet_four', host: 'BAD_HOST', loadTimeout: 0

topBar = new TopBar
topBar.el.appendTo document.body

User.fetch()

window.app = {stack, api, topBar}
module.exports = window.app
