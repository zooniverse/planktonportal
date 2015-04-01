require './lib/setup'

t7e = require 't7e'
LanguageManager = require 'zooniverse/lib/language-manager'
enUs = require './lib/en-us'

t7e.load enUs

languageManager = new LanguageManager
  translations:
    en: label: 'English', strings: enUs
    de: label: 'Deutsch', strings: './translations/de.json'
    fr: label: 'Français', strings: './translations/fr.json'
    pl: label: 'Polski', strings: './translations/pl.json'
    cs: label: 'Čeština', strings: './translations/cs.json'

languageManager.on 'change-language', (e, code, languageStrings) ->
  t7e.load languageStrings
  t7e.refresh()

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

  routes:
    '/': 'home'
    '/science/*': 'science'
    '/classify': 'classify'
    '/profile': 'profile'

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

Footer = require 'zooniverse/controllers/footer'
footer = new Footer
footer.el.appendTo document.body

Subject = require 'zooniverse/models/subject'
groups = require './lib/groups/'
default_subject_group = groups.mediterranean
Subject.group = default_subject_group

User = require 'zooniverse/models/user'
User.fetch()

GoogleAnalytics = require 'zooniverse/lib/google-analytics'
ga = new GoogleAnalytics account: 'UA-1224199-45'

window.app = {stack, api, topBar, ga}
module.exports = window.app
