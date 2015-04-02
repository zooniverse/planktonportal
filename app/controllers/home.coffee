Page = require './page'
template = require '../views/home'
Subject = require 'zooniverse/models/subject'
Stats = require './stats'
groups = require '../lib/groups'

class Home extends Page
  className: 'home'
  content: template

  events:
    'click input[name="group-selector"]': 'onClickGroupOption'

  elements:
    '#group_one': 'groupOneInput'
    '#group_two': 'groupTwoInput'

  constructor: ->
    super

    @setDefaultGroup()

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

  setDefaultGroup: ->
    @groups = groups

    default_subject_group = @groups.mediterranean
    groupOneCheckStatus = @groupOneInput.prop 'checked'
    groupTwoCheckStatus = @groupTwoInput.prop 'checked'

    if groupOneCheckStatus is false and groupTwoCheckStatus is false
      Subject.group = default_subject_group
      @checkGroupSelection()
    else
      @checkGroupSelection()

  checkGroupSelection: ->
    if Subject.group is @groups.mediterranean
      @groupOneInput.prop checked: true
    else
      @groupTwoInput.prop checked: true

  onClickGroupOption: ({currentTarget}) ->
    group = @groups["#{currentTarget.value}"]
    Subject.group = group
    @getSubject()

  getSubject: ->
    if Subject.current.group_id isnt Subject.group
      Subject.destroyAll()
      Subject.next()

  activate: ->
    super
    # TODO: Update the project stats.



module.exports = Home
