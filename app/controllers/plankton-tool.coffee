$ = window.jQuery
MarkingSurface = require 'marking-surface'
PointTool = require 'marking-surface/lib/tools/point'
{Point, ToolControls} = MarkingSurface
controlsTemplate = require('../views/plankton-chooser')()
species = require '../lib/species'

class PlanktonControls extends ToolControls
  template: controlsTemplate

  constructor: ->
    super
    # $(@el).append controlsTemplate
    console.log 'tool', @tool.markingSurface
    console.log 'template', controlsTemplate, typeof controlsTemplate
    # console.log '@template', @template
    @toggleButton = $(@el).find 'button[name="toggle"]'
    @categoryButtons = $(@el).find 'button[name="category"]'
    @categories = $(@el).find '.category'
    @speciesButtons = $(@el).find 'button[name="species"]'

    $(@el).on 'click', 'button[name="toggle"]', @onClickToggle
    $(@el).on 'click', 'button[name="category"]', @onClickCategory
    $(@el).on 'click', 'button[name="species"]', @onClickSpecies
    $(@el).on 'mouseover', @onEnter
    $(@el).on 'mouseout', @onLeave

    @toggleButton.click()


  onEnter: =>
    $(@tool).fadeOut()

  onLeave: =>
    $(@tool).fadeIn()

  onClickToggle: =>
    $(@el).removeClass 'closed'
    @moveTo {x: @outsideX, y: @outsideY}

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
      @moveTo {x: @outsideX, y: @outsideY}
    ), 250

    return if target.hasClass 'active'

    @speciesButtons.removeClass 'active'
    target.addClass 'active'

    @tool.mark.set species: target.val()

  # moveTo: (x, y, openLeft) ->
  #   if openLeft
  #     $(@el).addClass 'to-the-left'
  #     $(@el).css
  #       left: ''
  #       position: 'absolute'
  #       right: @tool.surface.width - x
  #       top: y

  #   else
  #     $(@el).removeClass 'to-the-left'
  #     $(@el).css
  #       left: x
  #       position: 'absolute'
  #       right: ''
  #       top: y

class PlanktonTool extends PointTool
  @Controls: PlanktonControls

  constructor: ->
    super

  initialize: ->
    super
    # @dot = @createShape 'circle', cx: 0, cy: 0, r: 10

  render: ->
    super
    # borrowed from penguins
    # @attr 'transform', "translate(#{@mark.x}, #{@mark.y})"
    # @controls.moveTo
    #   x: @mark.x + 30
    #   y: @mark.y

module.exports = PlanktonTool
