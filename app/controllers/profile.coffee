Page = require './page'
template = require '../views/profile'
LoginForm = require 'zooniverse/controllers/login-form'
Paginator = require 'zooniverse/controllers/paginator'
Recent = require 'zooniverse/models/recent'
Favorite = require 'zooniverse/models/favorite'
User = require 'zooniverse/models/user'

class Profile extends Page
  className: 'profile'

  events:
    'click button[name="page"]': 'onClickPage'

  constructor: ->
    super

    @html template

    @loginForm = new LoginForm
      el: @el.find '.sign-in-form'

    @recentsList = new Paginator
      type: Recent
      # itemTemplate: itemTemplate
      el: @el.find '.recents'

    @favoritesList = new Paginator
      type: Favorite
      # itemTemplate: itemTemplate
      el: @el.find '.favorites'

    @el.find('nav button').first().click()

    User.on 'change', =>
      @onUserChange arguments...

  onUserChange: (e, user) ->
    @el.toggleClass 'signed-in', user?

  onClickPage: (e) ->
    targetType = $(e.target).val()
    @recentsList.el.add(@favoritesList.el).removeClass 'active'
    @["#{targetType}List"].el.addClass 'active'

module.exports = Profile
