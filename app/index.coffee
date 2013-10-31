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
    profile: class extends Page then content: (new Profile).el
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

LanguageManager = require 'zooniverse/lib/language-manager'
languageManager = new LanguageManager
languageManager.on 'language-fetched', (e, languageStrings) ->
  translate.load languageStrings
  translate.refresh()

TopBar = require 'zooniverse/controllers/top-bar'
topBar = new TopBar
topBar.el.appendTo document.body

User = require 'zooniverse/models/user'
User.fetch()

GoogleAnalytics = require 'zooniverse/lib/google-analytics'
ga = new GoogleAnalytics account: 'UA-1224199-45'

window.app = {stack, api, topBar, ga}
module.exports = window.app
