$ = require 'jqueryify'
translate = require 't7e'
{Step} = require 'zootorial'

tutorial = null # Defined in the first step

module.exports = {}

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
  mark = tutorial.classifier.surface.marks[-1...][0]

  close = true
  close &&= closeTo mark.p0, [50, 0]
  close &&= closeTo mark.p1, [50, 100]
  close &&= closeTo mark.p2, [0, 50]
  close &&= closeTo mark.p3, [100, 50]

  right = mark.species is 'hydromedusa'

  # console.log {close, right}

  if close and right
    'markTheOtherOne'
  else if not close
    'firstBadCoordinates'
  else if not right
    'firstWrongSpecies'

afterSecond = ->

addStep 'welcome',
  number: 1
  next: ->
    tutorial = @
    'beforeMark'

addStep 'beforeMark',
  number: 2
  next: 'majorAxis'

addStep 'majorAxis',
  number: 3
  next: 'mouseup .marking-surface': 'minorAxis'

addStep 'minorAxis',
  number: 4
  next: 'mouseup .marking-surface': 'chooseCategory'

addStep 'chooseCategory',
  number: 5
  next: 'click button[name="category"]': 'chooseSpecies'

addStep 'chooseSpecies',
  number: 6
  next: 'click button[name="species"]': afterFirst

addStep 'firstBadCoordinates',
  header: translate 'div', 'tutorial.badCoordinates.header'
  details: translate 'div', 'tutorial.badCoordinates.details'
  instruction: translate 'div', 'tutorial.badCoordinates.instruction'

  onEnter: ->
    @guidelines = tutorial.classifier.surface.paper.path 'M 50 0 L 50 100 M 0 50 L 100 50'

  onExit: ->
    @guidelines.remove()
    delete @guidelines

  next: 'mouseup .marking-surface': afterFirst

addStep 'firstWrongSpecies',
  header: translate 'div', 'tutorial.wrongSpecies.header'
  details: (translate 'div', 'tutorial.wrongSpecies.details', {$species: 'Hydromedusa', $category: 'Multi-tentacled'})
  instruction: (translate 'div', 'tutorial.wrongSpecies.instruction', {$species: 'Hydromedusa', $category: 'Multi-tentacled'})

  actionable: 'button[value="tentacled"], button[value="hydromedusa"]'

  next: 'click button[name="species"]': afterFirst

addStep 'markTheOtherOne',
  number: 7
  next: afterSecond

addStep 'secondBadCoordinates', {}

addStep 'secondWrongSpecies', {}

addStep 'finish',
  number: 8

addStep 'beSocial',
  next: null

addStep 'haveFun', {}
