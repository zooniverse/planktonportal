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
    console.log 'tool marking surface', @
    # console.log 'template', controlsTemplate, typeof controlsTemplate
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

  # onEnter: =>
  #   $(@tool).fadeOut()

  # onLeave: =>
  #   $(@tool).fadeIn()

  onClickToggle: =>
    $(@el).removeClass 'closed'
    # @moveTo {}

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
      # @moveTo {x, y}
    ), 250

    return if target.hasClass 'active'

    @speciesButtons.removeClass 'active'
    target.addClass 'active'

    @tool.mark.set species: target.val()

  moveTo: (e) ->
    # if openLeft
    console.log 'x y', @el
    $(@el).addClass 'to-the-left'
    $(@el).css
      left: e.x - 400
      top: e.y


    # else
    #   $(@el).removeClass 'to-the-left'
    #   $(@el).css
    #     left: x
    #     position: 'absolute'
    #     right: ''
    #     top: y

class PlanktonTool extends PointTool
  @Controls: PlanktonControls

  constructor: ->
    super
    @label.el.style.display = 'none'

module.exports = PlanktonTool
