$ = require 'jqueryify'
translate = require 't7e'
{Step} = require 'zootorial'
User = require 'zooniverse/models/user'

surface = null # Defined in the first step

firstCreature  = p0: [817, 226], p1: [853, 333], p2: [765, 308], p3: [907, 254]
secondCreature = p0: [700, 112], p1: [721, 106], p2: [708, 102], p3: [714, 117]

module.exports =
  length: 9

addStep = (name, params) ->
  defaults = {
    header: translate 'div', "tutorial.#{name}.header", {fallback: ''}
    details: translate 'div', "tutorial.#{name}.details", {fallback: ''}
    instruction: translate 'div', "tutorial.#{name}.instruction", {fallback: '__NO_INSTRUCTION__'}
  }

  delete defaults.instruction if !!~defaults.instruction.indexOf '>__NO_INSTRUCTION__<'

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

  right = mark.species is 'hydromedusa'

  console.log 'first', {close, right}

  if close and right
    'markTheOtherOne'
  else if not close
    'firstBadCoordinates'
  else if not right
    'firstWrongSpecies'

afterSecond = ->
  mark = surface.marks[-1...][0]

  close = true
  close &&= closeTo mark.p0, secondCreature.p0
  close &&= closeTo mark.p1, secondCreature.p1
  close &&= closeTo mark.p2, secondCreature.p2
  close &&= closeTo mark.p3, secondCreature.p3

  right = mark.species is 'hydromedusa'

  if close and right
    'finish'
  else if not close
    'secondBadCoordinates'
  else if not right
    'secondWrongSpecies'

addStep 'welcome',
  number: 1
  next: ->
    surface = @classifier.surface
    'beforeMark'

addStep 'beforeMark',
  number: 2
  next: 'majorAxis'

addStep 'majorAxis',
  number: 3
  attachment: 'right middle .marking-surface 0.7 0.5'
  className: 'point-right'
  next: 'mouseup .marking-surface': 'minorAxis'

addStep 'minorAxis',
  number: 4
  attachment: 'right middle .marking-surface 0.7 0.5'
  className: 'point-right'
  next: 'mouseup .marking-surface': 'chooseCategory'

addStep 'chooseCategory',
  number: 5
  attachment: 'center bottom .marking-tool-controls center top'
  next: 'click button[name="category"]': 'chooseSpecies'

addStep 'chooseSpecies',
  number: 6
  attachment: 'center bottom .marking-tool-controls center top'
  next: 'click button[name="species"]': afterFirst

addStep 'firstBadCoordinates',
  header: translate 'div', 'tutorial.badCoordinates.header'
  details: translate 'div', 'tutorial.badCoordinates.details'
  instruction: translate 'div', 'tutorial.badCoordinates.instruction'
  attachment: 'right middle .marking-surface 0.7 0.5'
  className: 'point-right'

  onEnter: ->
    @guidelines = surface.paper.path """
      M #{firstCreature.p0[0]} #{firstCreature.p0[1]}
      L #{firstCreature.p1[0]} #{firstCreature.p1[1]}
      M #{firstCreature.p2[0]} #{firstCreature.p2[1]}
      L #{firstCreature.p3[0]} #{firstCreature.p3[1]}
    """

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
  details: (translate 'div', 'tutorial.wrongSpecies.details', {$species: 'Hydromedusa', $category: 'Multi-tentacled'})
  instruction: (translate 'div', 'tutorial.wrongSpecies.instruction', {$species: 'Hydromedusa', $category: 'Multi-tentacled'})
  attachment: 'center bottom .marking-tool-controls center top'

  actionable: 'button[value="tentacled"], button[value="hydromedusa"]'

  next: 'click button[name="species"]': afterFirst

addStep 'markTheOtherOne',
  number: 7
  attachment: 'center top .marking-surface 0.7 0.4'
  className: 'point-up'
  next: 'click button[name="species"]': afterSecond

addStep 'secondBadCoordinates',
  header: translate 'div', 'tutorial.badCoordinates.header'
  details: translate 'div', 'tutorial.badCoordinates.details'
  instruction: translate 'div', 'tutorial.badCoordinates.instruction'
  attachment: 'center top .marking-surface 0.7 0.4'
  className: 'point-up'

  onEnter: ->
    @guidelines = surface.paper.path """
      M #{secondCreature.p0[0]} #{secondCreature.p0[1]}
      L #{secondCreature.p1[0]} #{secondCreature.p1[1]}
      M #{secondCreature.p2[0]} #{secondCreature.p2[1]}
      L #{secondCreature.p3[0]} #{secondCreature.p3[1]}
    """

    @guidelines.attr
      'stroke': '#ff0'
      'stroke-dasharray': '-'
      'stroke-width': 2

  onExit: ->
    @guidelines.remove()
    delete @guidelines

  next: 'mouseup .marking-surface': afterSecond

addStep 'secondWrongSpecies',
  header: translate 'div', 'tutorial.wrongSpecies.header'
  details: (translate 'div', 'tutorial.wrongSpecies.details', {$species: 'Hydromedusa', $category: 'Multi-tentacled'})
  instruction: (translate 'div', 'tutorial.wrongSpecies.instruction', {$species: 'Hydromedusa', $category: 'Multi-tentacled'})
  attachment: 'center top .marking-surface 0.7 0.4'
  className: 'point-up'

  actionable: 'button[value="tentacled"], button[value="hydromedusa"]'

  next: 'click button[name="species"]': afterSecond

addStep 'finish',
  number: 8
  attachment: 'center bottom button[name="finish"] center top'
  next:
    # TODO: A click event never triggers for some reason, so use mousedown for now.
    'mousedown button[name="finish"]': ->
      if User.current?.project.splits.tutorial in ['a', 'd', 'i', 'g']
        'beSocial'
      else
        'haveFun'

addStep 'beSocial',
  next: ->
    if User.current?.project.splits.tutorial in ['a', 'd', 'i', 'g']
      'haveFun'
    else
      null

addStep 'haveFun',
  number: 9
  next: null
