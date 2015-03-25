$ = window.jQuery
MarkingSurface = require 'marking-surface'
PointTool = require 'marking-surface/lib/tools/point'
{Point, ToolControls} = MarkingSurface
controlsTemplate = require('../views/plankton-chooser')()
species = require '../lib/species'
Spine = require 'spine'

class PlanktonControls extends ToolControls
  template: controlsTemplate

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

    @toggleButton.html target.html()
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

  render: ->
    super
    EXTRA_SPACE = 20
    leftBound    = Math.min(@mark.x) - EXTRA_SPACE
    rightBound   = Math.max(@mark.x) + EXTRA_SPACE

    spaceLeft = leftBound
    spaceRight = @markingSurface.width - rightBound

    @openLeft = spaceLeft > spaceRight

module.exports = PlanktonTool
