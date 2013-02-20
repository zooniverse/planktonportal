MarkingSurface = require 'marking-surface'
AxesTool = require 'marking-surface/lib/tools/axes'
{ToolControls} = MarkingSurface
controlsTemplate = require '../views/plankton-chooser'

class PlanktonControls extends ToolControls
  constructor: ->
    super
    @el.append controlsTemplate
    @categoryButtons = @el.find 'button[name="category"]'
    @categories = @el.find '.category'
    @speciesButtons = @el.find 'button[name="species"]'

    @el.on 'click', 'button[name="category"]', @onClickCategory
    @el.on 'click', 'button[name="species"]', @onClickSpecies

  onClickCategory: ({target}) =>
    target = $(target)
    return if target.hasClass 'active'

    category = target.val()

    @categoryButtons.removeClass 'active'
    target.addClass 'active'

    @categories.removeClass 'active'
    @categories.filter(".#{category}").addClass 'active'

    @speciesButtons.removeClass 'active'

    @tool.mark.set species: null

  onClickSpecies: ({target}) =>
    target = $(target)
    return if target.hasClass 'active'

    species = target.val()

    @speciesButtons.removeClass 'active'
    target.addClass 'active'

    @tool.mark.set {species}

class PlanktonTool extends AxesTool
  @Controls: PlanktonControls

module.exports = PlanktonTool
