MarkingSurface = require 'marking-surface'
AxesTool = require 'marking-surface/lib/tools/axes'
{ToolControls} = MarkingSurface
controlsTemplate = require '../views/plankton-chooser'
species = require '../lib/species'

class PlanktonControls extends ToolControls
  intersectionX: NaN
  intersectionY: NaN
  outsideX: NaN
  outsideY: NaN
  openLeft: false
  guideTimeout: NaN

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
    @moveTo @outsideX, @outsideY, @openLeft

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
      @el.addClass 'closed'
      @moveTo @intersectionX, @intersectionY, @openLeft
    ), 250

    return if target.hasClass 'active'

    @speciesButtons.removeClass 'active'
    target.addClass 'active'

    @tool.mark.set species: target.val()

  moveTo: (x, y, openLeft) ->
    if openLeft
      @el.addClass 'to-the-left'
      @el.css
        left: ''
        position: 'absolute'
        right: @tool.surface.width - x
        top: y

    else
      @el.removeClass 'to-the-left'
      @el.css
        left: x
        position: 'absolute'
        right: ''
        top: y

class PlanktonTool extends AxesTool
  @Controls: PlanktonControls

  constructor: ->
    super

    @dots[2].attr r: @dots[2].attr('r') * 0.75
    @dots[3].attr r: @dots[3].attr('r') * 0.75

    indicatorSize = 25
    @directionIndicator = @addShape 'path', """
      M -#{indicatorSize * (2 / 3)} 0,
      L 0 -#{indicatorSize},
      L #{indicatorSize * (2 / 3)} 0,
      M 0 #{indicatorSize}
    """, 'stroke-width': 3

    @sizeGuide = @addShape 'circle', 0, 0, 0, fill: 'transparent', stroke: 'rgba(255, 255, 255, 0.5)', 'stroke-width': 1, 'stroke-dasharray': '3, 3'

  render: ->
    super

    stroke = if @mark.species? then '#c1ea00' else 'red'
    @cross.attr {stroke}
    @dots.attr {stroke}
    @directionIndicator.attr {stroke}

    majorAngle = 90 + Raphael.angle @mark.p0..., @mark.p1...
    @directionIndicator.transform "T #{@mark.p0[0]} #{@mark.p0[1]} R #{majorAngle}"

    EXTRA_SPACE = 20
    leftBound    = Math.min(@mark.p0[0], @mark.p1[0], @mark.p2[0], @mark.p3[0]) - EXTRA_SPACE
    rightBound   = Math.max(@mark.p0[0], @mark.p1[0], @mark.p2[0], @mark.p3[0]) + EXTRA_SPACE

    spaceLeft = leftBound
    spaceRight = @surface.width - rightBound

    openLeft = spaceLeft > spaceRight

    bestX = if openLeft then leftBound else rightBound
    averageX = (@mark.p0[0] + @mark.p1[0] + @mark.p2[0] + @mark.p3[0]) / 4
    averageY = (@mark.p0[1] + @mark.p1[1] + @mark.p2[1] + @mark.p3[1]) / 4

    @controls.outsideX = bestX
    @controls.outsideY = averageY
    @controls.openLeft = openLeft
    # @controls.moveTo bestX, averageY, openLeft

    majorPath = "M #{@mark.p0[0]} #{@mark.p0[1]}, L #{@mark.p1[0]} #{@mark.p1[1]}"
    minorPath = "M #{@mark.p2[0]} #{@mark.p2[1]}, L #{@mark.p3[0]} #{@mark.p3[1]}"
    [intersection] = Raphael.pathIntersection majorPath, minorPath
    intersection ?= x: averageX, y: averageY

    @controls.intersectionX = intersection.x
    @controls.intersectionY = intersection.y

    @sizeGuide.attr cx: intersection.x, cy: intersection.y

module.exports = PlanktonTool
