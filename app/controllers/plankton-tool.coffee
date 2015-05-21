$ = window.jQuery
MarkingSurface = require 'marking-surface'
PointTool = require 'marking-surface/lib/tools/point'
{ToolControls} = MarkingSurface
Subject = require 'zooniverse/models/subject'
controlsTemplateOriginal = require('../views/plankton-chooser-original')()
controlsTemplateMediterranean = require('../views/plankton-chooser-mediterranean')()
Spine = require 'spine'
groups = require '../lib/groups'

class PlanktonControls extends ToolControls

  constructor: ->
    super
    @toggleButton = $(@el).find 'button[name="toggle"]'

    $(@el).on 'click', 'button[name="toggle"]', @onClickToggle
    $(@el).on 'click', 'button[name="category"]', @onClickCategory
    $(@el).on 'click', 'button[name="species"]', @onClickSpecies
    $(@el).on 'click', 'button[name="delete-mark"]', @onClickDeleteMark

    @toggleButton.click()

    @template = if Subject.group is groups.mediterranean then controlsTemplateMediterranean else controlsTemplateOriginal
    @el.insertAdjacentHTML 'beforeEnd', @template

  onClickToggle: =>
    mark = @tool.el
    x = @tool.mark.x
    y = @tool.mark.y

    $(@el).removeClass 'closed'
    mark.classList.remove 'hidden'
    @moveTo({x,y})

  onClickCategory: ({currentTarget}) =>
    target = $(currentTarget)

    @categoryButtons = $(@el).find 'button[name="category"]'
    @categories = $(@el).find '.category'
    @speciesButtons = $(@el).find 'button[name="species"]'

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
    x = @tool.mark.x
    y = @tool.mark.y
    mark = @tool.el
    @toggleButton = $(@el).find 'button[name="toggle"]'

    @toggleButton.html '<i class="icon-marker">'
    @toggleButton.attr title: target.attr 'title'

    setTimeout (=>
      $(@el).addClass 'closed'
      mark.classList.add 'hidden'

      @moveTo({x, y})
    ), 250

    return if target.hasClass 'active'

    @speciesButtons.removeClass 'active'
    target.addClass 'active'

    @tool.mark.set species: target.val()
    Spine.trigger 'change-mark-count'

  onClickDeleteMark: =>
    @tool.mark.destroy()
    Spine.trigger 'change-mark-count'

  isFirefox: ->
    typeof InstallTrigger isnt 'undefined'

  moveTo: ({x,y})->
    super
    closedControls = @tool.controls?.el.classList.contains 'closed'
    toolControlsEl = $(@el)
    subtractionNum = if @isFirefox() then 420 else 400

    if @tool.openLeft
      toolControlsEl.addClass 'to-the-left'
      toolControlsEl.css
        left: if closedControls then x - 20 else x - subtractionNum
        top: y
    else
      toolControlsEl.removeClass 'to-the-left'
      toolControlsEl.css
        left: x
        top: y

class PlanktonTool extends PointTool
  @Controls: PlanktonControls

  constructor: ->
    super
    @label.el.style.display = 'none'

    @alert = @addShape 'path',
      d: "M1.393,8.212 C0.627,8.212 0.005,2.106 0.005,1.360 C0.005,0.614 0.627,0.009 1.393,0.009 C2.160,0.009 2.782,0.614 2.782,1.360 C2.782,2.106 2.160,8.212 1.393,8.212 ZM1.393,9.813 C2.160,9.813 2.782,10.417 2.782,11.163 C2.782,11.909 2.160,12.514 1.393,12.514 C0.627,12.514 0.005,11.909 0.005,11.163 C0.005,10.417 0.627,9.813 1.393,9.813 Z"
      fill: "#000000"
      class: "alert"

    @addEvent 'marking-surface:element:move', 'path', @onMove

  focus: ->
    @focused = false

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
