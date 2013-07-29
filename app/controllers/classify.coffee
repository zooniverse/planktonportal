$ = require 'jqueryify'
Page = require './page'
template = require '../views/classify'
translate = require 't7e'
MarkingSurface = require 'marking-surface'
Counter = require './counter'
moment = require 'moment'
PlanktonTool = require './plankton-tool'
User = require 'zooniverse/models/user'
Subject = require 'zooniverse/models/subject'
createTutorialSubject = require '../lib/create-tutorial-subject'
{Tutorial} = require 'zootorial'
tutorialSteps = require '../lib/tutorial-steps'
training = require '../lib/training'
Classification = require 'zooniverse/models/classification'
Favorite = require 'zooniverse/models/favorite'

$html = $('html')

sessionClassifications = 0

class Classify extends Page
  className: 'classify'
  content: template

  subjectTransition: 2000

  surface: null

  tutorial: null

  guidelines: null

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
    window.classifier = @
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

    @tutorial = new Tutorial
      parent: @el
      steps: tutorialSteps
      firstStep: 'welcome'

    @tutorial.classifier = @

  activate: ->
    super

    # Force rerender of the status bar
    status = @el.find '.status'
    status.css display: 'none'
    setTimeout ->
      status.css display: ''

    # Reposition the tutorial dialog.
    # TODO: This is weird, I know.
    setTimeout => @tutorial.attach()
    setTimeout (=> @tutorial.attach()), 300

  onUserChange: (e, user) =>
    sessionClassifications = user?.project.classification_count || 0

    # SPLIT | HEADING | PROGRESS | TALK
    # ------+---------+----------+---------
    # A     | NO      | NO       | TUTORIAL
    # B     | NO      | NO       | 1ST
    # C     | NO      | NO       | 5TH
    # D     | NO      | YES      | TUTORIAL
    # E     | NO      | YES      | 1ST
    # F     | NO      | YES      | 5TH
    # I     | YES     | NO       | TUTORIAL
    # J     | YES     | NO       | 1ST
    # K     | YES     | NO       | 5TH
    # G     | YES     | YES      | TUTORIAL
    # F     | YES     | YES      | 1ST
    # H     | YES     | YES      | 5TH

    split = user?.project.splits.tutorial
    $html.toggleClass 'no-tutorial-headers', split in ['a', 'b', 'c', 'd', 'e', 'f']
    $html.toggleClass 'no-tutorial-progress', split in ['a', 'b', 'c', 'i', 'j', 'k']

    if user?.project.tutorial_done
      if Subject.current?.metadata.tutorial
        @tutorial.end()
        Subject.next()
      else if not Subject.current?
        Subject.next()

    else
      tutorialSubject = createTutorialSubject()
      Subject.instances.unshift Subject.instances.pop()

      if @surface.marks.length is 0
        tutorialSubject.select()

  onGettingNextSubject: =>
    @el.addClass 'loading'

  onSubjectSelect: (e, subject) =>
    @el.removeClass 'training'
    @guidelines?.remove()
    @guidelines = null
    @guideIcons?.remove()
    @guideIcons = null

    @el.removeClass 'loading'
    @surface.marks[0].destroy() until @surface.marks.length is 0

    # This image will slide in.
    @newSwapImage.attr src: subject.location.standard

    # Show the swap container.
    @swapDrawer.css top: 0
    @swapContainer.css display: ''

    # Once the swap container is showing, change the image of the marking surface behind it.
    @surface.image.attr src: subject.location.standard
    @depthCounter.set (+subject.metadata.depth)?.toFixed(2) || '?'
    @tempCounter.set (+subject.metadata.temp)?.toFixed(2) || '?'
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

    if subject.metadata.tutorial
      @tutorial.start()

  onNoMoreSubjects: =>
    alert 'It appears we\'ve run out of data!'
    @el.removeClass 'loading'

  onChangeMarkCount: =>
    @creatureCounter.html @surface.marks.length

  onClickFinish: ->
    @checkTrainingSubject() if @classification.subject.metadata.training?

    sessionClassifications += 1

    trainingSubjects = [NaN, 3, 5, 7]

    if sessionClassifications in trainingSubjects
      console?.log sessionClassifications, 'Next subject will be training!'
      index = (i for item, i in trainingSubjects when item is sessionClassifications)[0]
      createTutorialSubject index
      Subject.instances.unshift Subject.instances.pop()

    @finishButton.attr disabled: true
    @nextButton.attr disabled: false
    @surface.disable()

    @surface.selection?.deselect()

    @classification.annotate mark for mark in @surface.marks

    # TODO: Send classification
    @classification.send()
    # console?.log 'Classifying', JSON.stringify @classification

    @el.addClass 'finished'

    classificationCount = User.current?.project.classificaiton_count || 0
    classificationCount += Classification.sentThisSession

    introduceTalk = if User.current?.project.splits.tutorial in ['b', 'e', 'j', 'f']
      1
    else if User.current?.project.splits.tutorial in ['c', 'f', 'k', 'h']
      5

    if classificationCount is introduceTalk
      setTimeout =>
        @tutorial.load 'beSocial'

  checkTrainingSubject: ->
    @el.addClass 'training'
    pathString = training.guidelines[@classification.subject.metadata.training]
    @guidelines = @surface.paper.path pathString
    @guidelines.attr stroke: '#3f3', 'stroke-width': 5

    @guideIcons = $()
    for {species, coords: [left, top]} in training.icons[@classification.subject.metadata.training]
      speciesClassName = species.replace(/([A-Z])/g, '-$1').toLowerCase()
      el = $("<i class='training-species-icon icon-#{speciesClassName}'></i>")
      el.css {left, top}
      @guideIcons.push.apply @guideIcons, el

    console.log {@guideIcons}
    @guideIcons.appendTo @el

  onClickFavorite: ->
    @favorite = new Favorite subjects: [@classification.subject]
    @favorite.on 'delete', @onFavoriteDelete

    @favorite.send()
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
