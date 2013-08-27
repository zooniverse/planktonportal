$ = require 'jqueryify'
translate = require 't7e'
{Step} = require 'zootorial'
User = require 'zooniverse/models/user'
training = require './training'

surface = null # Defined in the first step

firstCreature = do ->
  # It's actually the third (at index 2).
  [x0, y0, x1, y1, x2, y2, x3, y3] = training.guidelines[0].split('\n')[3].match /(\d+)/g
  p0: [x0, y0], p1: [x1, y1], p2: [x2, y2], p3: [x3, y3]

module.exports =
  length: 9

addStep = (name, params) ->
  defaults = {
    header: translate 'div', "tutorial.#{name}.header", {fallback: ''}
    details: translate 'div', "tutorial.#{name}.details", {fallback: ''}
    instruction: translate 'div', "tutorial.#{name}.instruction", {fallback: '__NO_INSTRUCTION__'}
  }

  delete defaults.instruction if !!~defaults.instruction.indexOf '>__NO_INSTRUCTION__<' # Kinda messy

  params = $.extend defaults, params

  module.exports[name] = new Step params

  null

closeTo = ([x, y], [idealX, idealY], allowed = 50) ->
  offX = Math.abs idealX - x
  offY = Math.abs idealY - y
  offBy = Math.sqrt Math.pow(offX, 2) + Math.pow(offY, 2)
  offBy < allowed

afterFirst = ->
  mark = surface.marks[-1...][0]

  close = true
  close &&= closeTo mark.p0, firstCreature.p0
  close &&= closeTo mark.p1, firstCreature.p1
  close &&= closeTo mark.p2, firstCreature.p2
  close &&= closeTo mark.p3, firstCreature.p3

  right = mark.species is 'solmaris'

  if close and right
    'markTheOtherOnes'
  else if not close
    'firstBadCoordinates'
  else if not right
    'firstWrongSpecies'

addStep 'welcome',
  number: 1
  block: 'button[name="finish"]'
  next: ->
    surface = @classifier.surface
    'beforeMark'

addStep 'beforeMark',
  number: 2
  attachment: 'center middle .marking-surface center 0.67'
  className: 'point-right'
  block: 'button[name="finish"]'
  next: 'majorAxis'

addStep 'majorAxis',
  number: 3
  attachment: 'center middle .marking-surface center 0.67'
  className: 'point-right'
  block: 'button[name="finish"]'
  next: 'mouseup .marking-surface': 'minorAxis'

addStep 'minorAxis',
  number: 4
  attachment: 'center middle .marking-surface center 0.67'
  className: 'point-right'
  block: 'button[name="finish"]'
  next: 'mouseup .marking-surface': 'chooseCategory'

addStep 'chooseCategory',
  number: 5
  attachment: 'center bottom .marking-tool-controls center top'
  block: 'button[name="finish"]'
  next: 'click button[name="category"]': 'chooseSpecies'

  onEnter: ->
    surface.selection.controls.toggleButton.click()

addStep 'chooseSpecies',
  number: 6
  attachment: 'center bottom .marking-tool-controls center top'
  block: 'button[name="finish"]'
  next: 'click button[name="species"]': afterFirst

addStep 'firstBadCoordinates',
  header: translate 'div', 'tutorial.badCoordinates.header'
  details: translate 'div', 'tutorial.badCoordinates.details'
  instruction: translate 'div', 'tutorial.badCoordinates.instruction'
  attachment: 'right middle .marking-surface 0.7 0.5'
  className: 'point-right'

  onEnter: ->
    @guidelines = surface.paper.path training.guidelines[0].split('\n')[3]

    @guidelines.attr
      'stroke': '#ff0'
      'stroke-dasharray': '-'
      'stroke-width': 2

  onExit: ->
    @guidelines.remove()
    delete @guidelines

  next: 'mouseup .marking-surface': afterFirst

addStep 'firstWrongSpecies',
  header: translate 'div', 'tutorial.wrongSpecies.header'
  details: (translate 'div', 'tutorial.wrongSpecies.details', {$species: 'Solmaris', $category: 'Tentacled'})
  instruction: (translate 'div', 'tutorial.wrongSpecies.instruction', {$species: 'Solmaris', $category: 'Tentacled'})
  attachment: 'center bottom .marking-tool-controls center top'

  actionable: 'button[value="tentacled"], button[value="solmaris"]'

  next: 'click button[name="species"]': afterFirst

  onEnter: ->
    surface.tools[0].controls.onClickToggle()

addStep 'markTheOtherOnes',
  number: 7
  attachment: 'center bottom .marking-surface 0.75 bottom'
  actionable: 'button[name="finish"]'
  next:
    # TODO: A click event never triggers for some reason, so use mousedown for now.
    'mousedown button[name="finish"]': 'dontMarkThese'

  onEnter: ->
    individualGuides = training.guidelines[0].split '\n'

    @guidelines = surface.paper.path """
      #{individualGuides[0]}
      #{individualGuides[1]}
      #{individualGuides[2]}
      #{individualGuides[4]}
    """

    @guidelines.attr
      'stroke': '#ff0'
      'stroke-dasharray': '-'
      'stroke-width': 2

    @guideIcons = $()
    for {species, coords: [left, top]} in training.icons[0]
      speciesClassName = species.replace(/([A-Z])/g, '-$1').toLowerCase()
      el = $("<i class='training-species-icon icon-#{speciesClassName}'></i>")
      el.css {left, top}
      el.appendTo window.classifier.surface.container # TODO
      @guideIcons.push.apply @guideIcons, el

  onExit: (tutorial) ->
    @guidelines.remove()
    delete @guidelines

    # Check to see if we've actually exited the tutorial.
    @guideIcons.remove()
    delete @guideIcons

addStep 'dontMarkThese',
  number: 8
  attachment: 'right top .marking-surface 0.85 0.15'
  next: ->
    if User.current?.project?.splits.tutorial in ['a', 'd', 'i', 'g']
      'beSocial'
    else
      'haveFun'

  onEnter: ->
    @guideCircles = surface.paper.set()
    @guideLabels = $()

    for thing, {cx, cy, r} of training.dontMark
      circle = surface.paper.circle cx, cy, r
      circle.attr
        'stroke': '#f00'
        'stroke-dasharray': '-'
        'stroke-width': 2

      @guideCircles.push circle

      label = $(translate 'span.training-dont-mark-label', "tutorial.dontMarkThese.#{thing}")
      label.css
        left: cx
        top: cy + r + 5
      label.appendTo window.classifier.surface.container # TODO

      @guideLabels.push label...

  onExit: ->
    circle.remove() for circle in @guideCircles
    delete @guideCircles

    @guideLabels.remove()
    delete @guideLabels

addStep 'beSocial',
  next: ->
    if User.current?.project?.splits.tutorial in ['a', 'd', 'i', 'g']
      'haveFun'
    else
      null

addStep 'haveFun',
  number: 9
  next: null
  nextButton: translate 'tutorial.haveFun.nextButton'
