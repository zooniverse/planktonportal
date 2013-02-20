MarkingSurface = require 'marking-surface'
AxesTool = require 'marking-surface/lib/tools/axes'
{ToolControls} = MarkingSurface
controlsTemplate = require '../views/plankton-chooser'

class PlanktonControls extends ToolControls
  constructor: ->
    super

    @el.append controlsTemplate

class PlanktonTool extends AxesTool
  @Controls: PlanktonControls

  initialize: ->
    super

module.exports = AxesTool
