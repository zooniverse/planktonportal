Page = require './page'
template = require '../views/classify'
translate = require 't7e'
MarkingSurface = require 'marking-surface'
Counter = require './counter'
moment = require 'moment'
PlanktonTool = require './plankton-tool'
User = require 'zooniverse/models/user'
Subject = require 'zooniverse/models/subject'
Classification = require 'zooniverse/models/classification'
Favorite = require 'zooniverse/models/favorite'

class Classify extends Page
  className: 'classify'
  content: template

  subjectTransition: 2000

  surface: null

  events:
    'click button[name="finish"]': 'onClickFinish'
    'click button[name="favorite"]': 'onClickFavorite'
    'click button[name="next"]': 'onClickNext'

  elements:
    '.swap-container': 'swapContainer'
    '.swap-container .drawer': 'swapDrawer'
    '.swap-container .old': 'oldSwapImage'
    '.swap-container .new': 'newSwapImage'
    '.depth .counter': 'depthCounterEl'
    '.temp .counter': 'tempCounterEl'
    '.time .counter': 'timeEl'
    '.creatures .number .counter': 'creatureCounter'
    'button[name="finish"]': 'finishButton'
    'button[name="next"]': 'nextButton'
    'a.talk': 'talkLink'
    'a.facebook': 'facebookLink'
    'a.twitter': 'twitterLink'

  constructor: ->
    super

    @el.addClass 'loading'

    @surface ?= new MarkingSurface
      tool: PlanktonTool
      container: @el.find '.subject-container'
      width: 1024
      height: 560

    @surface.on 'create-mark destroy-mark', @onChangeMarkCount

    @depthCounter = new Counter el: @depthCounterEl
    @tempCounter = new Counter el: @tempCounterEl

    User.on 'change', @onUserChange

    Subject.on 'get-next', @onGettingNextSubject
    Subject.on 'select', @onSubjectSelect
    Subject.on 'no-more', @onNoMoreSubjects

    Favorite.on 'from-classify'

  activate: ->
    super

    # Force rerender of the status bar
    status = @el.find('.status')
    status.css display: 'none'
    setTimeout ->
      status.css display: ''

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
    @swapDrawer.css top: 0
    @swapContainer.css display: ''

    # Once the swap container is showing, change the image of the marking surface behind it.
    @surface.image.attr src: subject.location.standard
    @depthCounter.set subject.metadata.depth.toFixed(2) || '?'
    @tempCounter.set subject.metadata.temp.toFixed(2) || '?'
    @timeEl.html moment(subject.metadata.timestamp).format 'YYYY/M/D'

    @swapDrawer.delay(250).animate top: -@surface.height, @subjectTransition, =>
      @swapContainer.css display: 'none'

      # This will slide out next time.
      @oldSwapImage.attr src: subject.location.standard

      @finishButton.attr disabled: false
      @surface.enable()

      @classification = new Classification {subject}

    @talkLink.attr href: subject.talkHref()
    @facebookLink.attr href: subject.facebookHref()
    @twitterLink.attr href: subject.twitterHref()

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

    @classification.annotate mark for mark in @surface.marks

    # TODO: Send classification
    # @classification.send()
    console?.log 'Classifying', JSON.stringify @classification

    @el.addClass 'finished'

  onClickFavorite: ->
    @favorite = new Favorite subjects: [@classification.subject]
    @favorite.on 'delete', @onFavoriteDelete

    favorite.send()
    @el.addClass 'is-favorite'

  onClickUnfavorite: ->
    @favorite?.delete()

  onFavoriteDelete: =>
    @el.removeClass 'is-favorite'

  onClickNext: ->
    @nextButton.attr disabled: true

    Subject.next()

    @el.removeClass 'finished'

module.exports = Classify
