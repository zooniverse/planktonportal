Page = require './page'
template = require '../views/home'
Footer = require 'zooniverse/controllers/footer'
Subject = require 'zooniverse/models/subject'

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

    @footer = new Footer
    @el.append @footer.el

    @setDefaultGroup()

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
    console.log 'group', group
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
