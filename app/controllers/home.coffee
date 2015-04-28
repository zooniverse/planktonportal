User = require 'zooniverse/models/user'
Subject = require 'zooniverse/models/subject'

Spine = require 'spine'
Page = require './page'
Stats = require './stats'

template = require '../views/home'
groups = require '../lib/groups'

class Home extends Page
  className: 'home'
  content: template

  events:
    'click button[name="group-selector"]': 'onClickGroupOption'

  elements:
    '#group_one': 'groupOneInput'
    '#group_two': 'groupTwoInput'

  constructor: ->
    super

    stats = new Stats
    @el.append stats.el

    projectFetch = $.getJSON "https://api.zooniverse.org/projects/plankton"
    statusFetch = $.getJSON "https://api.zooniverse.org/projects/plankton/status?status_type=subjects"

    $.when(projectFetch, statusFetch).done (projectResult, statusResult) =>
      return unless projectResult[1] == 'success' && statusResult[1] == 'success'

      stats.classificationCount = projectResult[0].classification_count
      stats.completeCount = projectResult[0].complete_count
      stats.userCount = projectResult[0].user_count
      stats.subjectCount = statusResult[0].reduce (p, v) ->
        p + v.count
      , 0

      stats.percentComplete()
      stats.updateTemplate()

      User.on 'change', @onUserChange
      Spine.on 'setGroupButtonActive', @setGroupButtonActive

  onUserChange: (e, user) =>
    Spine.trigger 'setDefaultGroup' if @onHome()

  onHome: =>
    window.location.hash is "#/"

  setGroupButtonActive: =>
    if Subject.group is groups.mediterranean
      @groupOneInput.addClass('active').siblings().removeClass 'active'
    else
      @groupTwoInput.addClass('active').siblings().removeClass 'active'

  onClickGroupOption: ({currentTarget}) ->
    button = $(currentTarget)
    group = groups["#{currentTarget.value}"]
    Subject.group = group
    @getSubject()

    if button.hasClass 'active'
      event.preventDefault()
    else
      @setUserPreference(group)
      button.toggleClass('active').siblings().toggleClass 'active'

  setUserPreference: (preference) ->
    if User.current
      User.current.setPreference 'group', preference

  getSubject: ->
    if Subject.current.group_id isnt Subject.group
      Subject.destroyAll()
      Subject.next()

  activate: ->
    super

module.exports = Home
