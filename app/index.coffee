require './lib/setup'

Navigation = require './controllers/navigation'
navigation = new Navigation
navigation.el.appendTo document.body

translate = require 't7e'
{Stack} = require 'spine/lib/manager'
Page = require './controllers/page'
Home = require './controllers/home'
Science = require './controllers/science'
Classify = require './controllers/classify'
{Controller} = require 'spine'
Profile = require 'zooniverse/controllers/profile'
Team = require './controllers/team'

stack = new Stack
  controllers:
    home: Home
    science: Science
    classify: Classify
    profile: class extends Controller then constructor: -> super; @html new Profile
    education: class extends Page then content: translate 'div', 'education.content'
    team: Team

  routes:
    '/': 'home'
    '/science/*': 'science'
    '/classify': 'classify'
    '/profile': 'profile'
    '/education': 'education'
    '/team': 'team'

  default: 'home'

stack.el.appendTo document.body

Route = require 'spine/lib/route'
Route.setup()

activeHashLinks = require 'zooniverse/util/active-hash-links'
activeHashLinks.init()

Api = require 'zooniverse/lib/api'
api = new Api project: 'plankton'

TopBar = require 'zooniverse/controllers/top-bar'
topBar = new TopBar
topBar.el.appendTo document.body

User = require 'zooniverse/models/user'
User.fetch()

window.app = {stack, api, topBar}
module.exports = window.app
