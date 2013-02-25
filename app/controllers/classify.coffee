Page = require './page'
template = require '../views/classify'
translate = require 't7e'
MarkingSurface = require 'marking-surface'
PlanktonTool = require './plankton-tool'
User = require 'zooniverse/models/user'
Subject = require 'zooniverse/models/subject'
Classification = require 'zooniverse/models/classification'

class Classify extends Page
  className: 'classify'

  surface: null

  events:
    'click button[name="finish"]': 'onClickFinish'
    'click button[name="favorite"]': 'onClickFavorite'
    'click button[name="next"]': 'onClickNext'

  elements:
    '.swap .drawer': 'swapDrawer'
    '.swap .old': 'oldSwapImage'
    '.swap .new': 'newSwapImage'
    '.creatures .number .counter': 'creatureCounter'
    'button[name="finish"]': 'finishButton'
    'button[name="next"]': 'nextButton'

  constructor: ->
    super
    @html template
    @el.addClass 'loading'

    @surface ?= new MarkingSurface
      tool: PlanktonTool
      container: @el.find '.subject'
      width: 1024
      height: 562

    @surface.on 'create-mark destroy-mark', @onChangeMarkCount

    User.on 'change', @onUserChange
    Subject.on 'get-next', @onGettingNextSubject
    Subject.on 'select', @onSubjectSelect
    Subject.on 'no-more', @onNoMoreSubjects

  onUserChange: =>
    Subject.next()

  onGettingNextSubject: =>
    @el.addClass 'loading'

  onSubjectSelect: (e, subject) =>
    @el.removeClass 'loading'
    @surface.marks[0].destroy() until @surface.marks.length is 0

    # This image will slide in.
    @newSwapImage.attr src: subject.location.standard

    # Show the swap container.
    @swapDrawer.css display: '', top: 0

    # Once the swap container is showing, change the image of the marking surface behind it.
    @surface.image.attr src: subject.location.standard

    @swapDrawer.animate top: -562, 'slow', =>
      @swapDrawer.css display: 'none'

      # This will slide out next time.
      @oldSwapImage.attr src: subject.location.standard

      @finishButton.attr disabled: false
      @surface.enable()

      @classification = new Classification {subject}

  onNoMoreSubjects: =>
    alert 'It appears we\'ve run out of data!'
    @el.removeClass 'loading'

  onChangeMarkCount: =>
    @creatureCounter.html @surface.marks.length

  onClickFinish: ->
    @finishButton.attr disabled: true
    @nextButton.attr disabled: false
    @surface.disable()

    @surface.selection?.deselect()

    # TODO: Add marks to classification
    # TODO: Send classification

    @el.addClass 'finished'

  onClickFavorite: ->

  onClickNext: ->
    @nextButton.attr disabled: true

    Subject.next()

    @el.removeClass 'finished'

module.exports = Classify
