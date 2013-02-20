require './lib/setup'

{Stack} = require 'spine/lib/manager'
Home = require './controllers/home'
About = require './controllers/about'
Classify = require './controllers/classify'
Profile = require './controllers/profile'
Route = require 'spine/lib/route'

Api = require 'zooniverse/lib/api'
TopBar = require 'zooniverse/controllers/top-bar'

stack = new Stack
  controllers:
    home: Home
    about: About
    classify: Classify
    profile: Profile

  routes:
    '/': 'home'
    '/about': 'about'
    '/classify': 'classify'
    '/profile': 'profile'

  default: 'home'

stack.el.appendTo document.body

Route.setup()

api = new Api project: 'planet_four'

topBar = new TopBar
topBar.el.appendTo document.body

module.exports = {stack, api, topBar}
