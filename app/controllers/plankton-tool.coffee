MarkingSurface = require 'marking-surface'
AxesTool = require 'marking-surface/lib/tools/axes'
{ToolControls} = MarkingSurface
controlsTemplate = require '../views/plankton-chooser'

class PlanktonControls extends ToolControls
  constructor: ->
    super

    @el.append controlsTemplate
    @toggleButton = @el.find 'button[name="toggle"]'
    @categoryButtons = @el.find 'button[name="category"]'
    @categories = @el.find '.category'
    @speciesButtons = @el.find 'button[name="species"]'

    @el.on 'click', 'button[name="toggle"]', @onClickToggle
    @el.on 'click', 'button[name="category"]', @onClickCategory
    @el.on 'click', 'button[name="species"]', @onClickSpecies

    @toggleButton.click()

  onClickToggle: =>
    @el.removeClass 'closed'

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

    setTimeout (=> @el.addClass 'closed'), 250

    return if target.hasClass 'active'

    @speciesButtons.removeClass 'active'
    target.addClass 'active'

    @tool.mark.set species: target.val()

class PlanktonTool extends AxesTool
  @Controls: PlanktonControls

  constructor: ->
    super

    @dots[2].attr r: @dots[2].attr('r') * 0.75
    @dots[3].attr r: @dots[3].attr('r') * 0.75
    @directionIndicator = @addShape 'path', 'M -20 0, L 0 -30, L 20 0, M 0 30', 'stroke-width': 3

  render: ->
    super

    stroke = if @mark.species? then '#c1ea00' else 'red'
    @cross.attr {stroke}
    @dots.attr {stroke}
    @directionIndicator.attr {stroke}

    majorAngle = 90 + Raphael.angle @mark.p0..., @mark.p1...
    @directionIndicator.transform "T #{@mark.p0[0]} #{@mark.p0[1]} R #{majorAngle}"

module.exports = PlanktonTool
