Page = require './page'
template = require '../views/home'
Footer = require 'zooniverse/controllers/footer'
Subject = require 'zooniverse/models/subject'

class Home extends Page
  className: 'home'
  content: template

  events:
    'click input[name="group-selector"]': 'onClickGroupOption'
    # 'click #group_two': @onClickGroupOption

  elements:
    '#group_one': 'groupOneInput'
    '#group_two': 'groupTwoInput'

  california: "536d226d3ae740fd20000003"

  tasmania: "53ac8475edf877f0bc000002"

  constructor: ->
    super

    @footer = new Footer
    @el.append @footer.el

    @setDefaultGroup()

  setDefaultGroup: ->
    default_subject_group = @california
    groupOneCheckStatus = @groupOneInput.prop 'checked'
    groupTwoCheckStatus = @groupTwoInput.prop 'checked'

    if groupOneCheckStatus is false and groupTwoCheckStatus is false
      Subject.group = default_subject_group
      @checkGroupSelection()
    else
      @checkGroupSelection()

  checkGroupSelection: ->
    if Subject.group is @california
      console.log 'subject group cali', Subject.current
      @groupOneInput.prop checked: true
    else if Subject.group is @tasmania
      @groupTwoInput.prop checked: true

  onClickGroupOption: ({currentTarget}) ->
    console.log 'click', currentTarget.value
    Subject.group = currentTarget.value
    @getSubject()

  getSubject: ->
    if Subject.current.group_id isnt Subject.group
      console.log 'current group doesnt match'
      Subject.destroyAll()
      Subject.next()

  activate: ->
    super
    # TODO: Update the project stats.



module.exports = Home
