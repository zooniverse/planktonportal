$ = require 'jqueryify'
translate = require 't7e'
{Step} = require 'zootorial'
User = require 'zooniverse/models/user'

tutorial = null # Defined in the first step

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
  mark = tutorial.classifier.surface.marks[-1...][0]

  close = true
  close &&= closeTo mark.p0, [50, 0]
  close &&= closeTo mark.p1, [50, 100]
  close &&= closeTo mark.p2, [0, 50]
  close &&= closeTo mark.p3, [100, 50]

  right = mark.species is 'hydromedusa'

  if close and right
    'markTheOtherOne'
  else if not close
    'firstBadCoordinates'
  else if not right
    'firstWrongSpecies'

afterSecond = ->
  mark = tutorial.classifier.surface.marks[-1...][0]

  close = true
  close &&= closeTo mark.p0, [150, 100]
  close &&= closeTo mark.p1, [150, 200]
  close &&= closeTo mark.p2, [100, 150]
  close &&= closeTo mark.p3, [200, 150]

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
  next: 'click button[name="species"]': afterSecond

addStep 'secondBadCoordinates',
  header: translate 'div', 'tutorial.badCoordinates.header'
  details: translate 'div', 'tutorial.badCoordinates.details'
  instruction: translate 'div', 'tutorial.badCoordinates.instruction'

  onEnter: ->
    @guidelines = tutorial.classifier.surface.paper.path 'M 150 100 L 150 200 M 100 150 L 200 150'

  onExit: ->
    @guidelines.remove()
    delete @guidelines

  next: 'mouseup .marking-surface': afterSecond

addStep 'secondWrongSpecies',
  header: translate 'div', 'tutorial.wrongSpecies.header'
  details: (translate 'div', 'tutorial.wrongSpecies.details', {$species: 'Hydromedusa', $category: 'Multi-tentacled'})
  instruction: (translate 'div', 'tutorial.wrongSpecies.instruction', {$species: 'Hydromedusa', $category: 'Multi-tentacled'})

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
