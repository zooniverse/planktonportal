$ = window.jQuery
MarkingSurface = require 'marking-surface'
PointTool = require 'marking-surface/lib/tools/point'
{Point, ToolControls} = MarkingSurface
Subject = require 'zooniverse/models/subject'
controlsTemplateOriginal = require('../views/plankton-chooser-original')()
controlsTemplateMediterranean = require('../views/plankton-chooser-mediterranean')()
Spine = require 'spine'
groups = require '../lib/groups'

class PlanktonControls extends ToolControls
  template: if Subject.group is groups.mediterranean then controlsTemplateMediterranean else controlsTemplateOriginal

  constructor: ->
    super
    @toggleButton = $(@el).find 'button[name="toggle"]'
    @categoryButtons = $(@el).find 'button[name="category"]'
    @categories = $(@el).find '.category'
    @speciesButtons = $(@el).find 'button[name="species"]'

    $(@el).on 'click', 'button[name="toggle"]', @onClickToggle
    $(@el).on 'click', 'button[name="category"]', @onClickCategory
    $(@el).on 'click', 'button[name="species"]', @onClickSpecies
    $(@el).on 'click', 'button[name="delete-mark"]', @onClickDeleteMark

    @toggleButton.click()

    console.log 'template', @template

  onClickToggle: =>
    $(@el).removeClass 'closed'
    @moveTo()

  onClickCategory: ({currentTarget}) =>
    target = $(currentTarget)

    category = if target.hasClass 'active'
      'NO_CATEGORY'
    else
      target.val()

    @categories.add(@categoryButtons).removeClass 'active'

    @categoryButtons.filter("[value='#{category}']").addClass 'active'
    @categories.filter(".#{category}").addClass 'active'

    @speciesButtons.removeClass 'active'

    @tool.mark.set species: null

  onClickSpecies: ({currentTarget}) =>
    target = $(currentTarget)

    @toggleButton.html '<i class="icon-marker">'
    @toggleButton.attr title: target.attr 'title'

    setTimeout (=>
      $(@el).addClass 'closed'
      @moveTo()
    ), 250

    return if target.hasClass 'active'

    @speciesButtons.removeClass 'active'
    target.addClass 'active'

    @tool.mark.set species: target.val()
    Spine.trigger 'change-mark-count'

  onClickDeleteMark: =>
    @tool.mark.destroy()
    Spine.trigger 'change-mark-count'

  moveTo: =>
    closedControls = @tool.controls?.el.classList.contains 'closed'
    targetX = @tool.mark.x
    targetY = @tool.mark.y

    if @tool.openLeft
      $(@el).addClass 'to-the-left'
      $(@el).css
        left: if closedControls then targetX - 20 else targetX - 400
        top: targetY
    else
      $(@el).removeClass 'to-the-left'
      $(@el).css
        left: targetX
        top: targetY

class PlanktonTool extends PointTool
  @Controls: PlanktonControls

  constructor: ->
    super
    @label.el.style.display = 'none'

    @alert = @addShape 'path',
      d: "M1.393,8.212 C0.627,8.212 0.005,2.106 0.005,1.360 C0.005,0.614 0.627,0.009 1.393,0.009 C2.160,0.009 2.782,0.614 2.782,1.360 C2.782,2.106 2.160,8.212 1.393,8.212 ZM1.393,9.813 C2.160,9.813 2.782,10.417 2.782,11.163 C2.782,11.909 2.160,12.514 1.393,12.514 C0.627,12.514 0.005,11.909 0.005,11.163 C0.005,10.417 0.627,9.813 1.393,9.813 Z"
      fill: "#000000"
      class: "alert"

  render: ->
    super
    EXTRA_SPACE = 20
    leftBound    = Math.min(@mark.x) - EXTRA_SPACE
    rightBound   = Math.max(@mark.x) + EXTRA_SPACE

    spaceLeft = leftBound
    spaceRight = @markingSurface.width - rightBound

    @openLeft = spaceLeft > spaceRight

    @ticks.attr
      d: "M10.000,-0.001 C4.480,-0.001 0.004,4.499 0.004,10.051 C0.004,18.071 10.000,27.006 10.000,27.006 C10.000,27.006 19.997,18.071 19.997,10.051 C19.997,4.499 15.521,-0.001 10.000,-0.001 Z"
      stroke: "transparent"
      fill: "#c1ea00"
      class: "marker"

module.exports = PlanktonTool
