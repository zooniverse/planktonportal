Page = require './page'
template = require '../views/profile'
itemTemplate = require '../views/profile-item'
LoginForm = require 'zooniverse/controllers/login-form'
Paginator = require 'zooniverse/controllers/paginator'
Recent = require 'zooniverse/models/recent'
Favorite = require 'zooniverse/models/favorite'
User = require 'zooniverse/models/user'

class Profile extends Page
  className: 'profile'

  events:
    'click button[name="turn-page"]': 'onClickPage'

  elements:
    'button[name="turn-page"]': 'pageTurners'

  constructor: ->
    super

    @html template

    @loginForm = new LoginForm
      el: @el.find '.sign-in-form'

    @recentsList = new Paginator
      type: Recent
      itemTemplate: itemTemplate
      el: @el.find '.recents'

    @favoritesList = new Paginator
      type: Favorite
      itemTemplate: itemTemplate
      el: @el.find '.favorites'

    @el.find('nav button').first().click()

    User.on 'change', =>
      @onUserChange arguments...

  onUserChange: (e, user) ->
    @el.toggleClass 'signed-in', user?

  onClickPage: (e) ->
    @pageTurners.removeClass 'active'
    target = $(e.target)
    target.addClass 'active'
    targetType = target.val()
    console.log to: targetType
    @recentsList.el.add(@favoritesList.el).removeClass 'active'
    @["#{targetType}List"].el.addClass 'active'

module.exports = Profile
