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
groups = require '../lib/groups'
species = require '../lib/species'
# createTutorialSubject = require '../lib/create-tutorial-subject'
# {Tutorial} = require 'zootorial'
# tutorialSteps = require '../lib/tutorial-steps'
# training = require '../lib/training'
loginDialog = require 'zooniverse/controllers/login-dialog'
Classification = require 'zooniverse/models/classification'
Favorite = require 'zooniverse/models/favorite'
{PointTool} = MarkingSurface
Spine = require 'spine'
SlideTutorial = require 'slide-tutorial'
slides = require '../lib/slides.coffee'

$html = $('html')

sessionClassifications = 0

class Classify extends Page
  className: 'classify'
  content: template

  subjectTransition: 2000

  surface: null

  currentSubjectImage: null

  guidelines: null

  events:
    'click button[name="finish"]': 'onClickFinish'
    'click button[name="tutorial"]': 'onClickTutorial'
    'click button[name="sign-in"]': 'onClickSignIn'
    'click button[name="favorite"]': 'onClickFavorite'
    'click button[name="unfavorite"]': 'onClickUnfavorite'
    'click button[name="next"]': 'onClickNext'

  elements:
    '.subject-container': 'subjectContainer'
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
    'button[name="favorite"]': 'favButton'
    'a.talk': 'talkLink'
    'a.facebook': 'facebookLink'
    'a.twitter': 'twitterLink'
    'span#group-name': 'groupName'

  constructor: ->
    window.classifier = @
    super

    @el.addClass 'loading'

    @surface = new MarkingSurface
      tool: PlanktonTool
      width: 1024
      height: 560
      scaleX: 1
      scaleY: 1

    @subjectContainer.prepend @surface.el

    Spine.on 'change-mark-count', @onChangeMarkCount

    @depthCounter = new Counter el: @depthCounterEl
    @tempCounter = new Counter el: @tempCounterEl

    User.on 'change', @onUserChange

    Subject.on 'get-next', @onGettingNextSubject
    Subject.on 'select', @onSubjectSelect
    Subject.on 'no-more', @onNoMoreSubjects

    Favorite.on 'from-classify', @onFavoriteFromClassify

    @slideTutorial = new SlideTutorial slides: slides

  activate: ->
    super
    @startTutorial() if @onClassify()

    # Force rerender of the status bar
    status = @el.find '.status'
    status.css display: 'none'
    setTimeout ->
      status.css display: ''

  onUserChange: (e, user) =>
    @el.toggleClass 'signed-in', user?

    sessionClassifications = user?.project?.classification_count || 0

    Subject.next()

    @startTutorial if @onClassify()

  firstVisit: (user) =>
    return true unless user
    !user?.project?.classification_count

  startTutorial: =>
    @slideTutorial.start() if @firstVisit User.current

  onClassify: =>
    window.location.hash is "#/classify"

  onGettingNextSubject: =>
    @el.addClass 'loading'

  onSubjectSelect: (e, subject) =>
    @el.removeClass 'loading'
    @surface.tools[0].destroy() until @surface.tools.length is 0

    # This image will slide in.
    @newSwapImage.attr src: subject.location.standard

    # Show the swap container.
    @swapDrawer.css top: 0
    @swapContainer.css display: ''

    # Once the swap container is showing, change the image of the marking surface behind it.
    @depthCounter.set (+subject.metadata.depth)?.toFixed(2) || '?'
    @tempCounter.set (+subject.metadata.temp)?.toFixed(2) || '?'
    @timeEl.html moment(subject.metadata.timestamp).format 'YYYY/M/D'
    @loadImage subject.location.standard, ({src, width, height}) =>
      @surface.image = @surface.addShape 'image', 'xlink:href': src, width: width, height: height, preserveAspectRatio: 'none'
      @surface.svg.attr width: width, height: height
      @surface.svg.attr 'viewBox', [0, 0, width, height].join ' '

    @swapDrawer.delay(250).animate top: -@surface.height, @subjectTransition, =>
      @swapContainer.css display: 'none'

      # This will slide out next time.
      @oldSwapImage.attr src: subject.location.standard

      @finishButton.attr disabled: false
      @surface.enable()

      @classification = new Classification {subject}

    @el.removeClass 'is-favorite'
    @talkLink.attr href: subject.talkHref()
    @facebookLink.attr href: subject.facebookHref()
    @twitterLink.attr href: subject.twitterHref()
    @groupName.html subject.group.name

  loadImage: (src, cb) ->
    img = new Image
    img.onload = -> cb img
    img.src = src

  onNoMoreSubjects: =>
    alert 'It appears we\'ve run out of data!'
    @el.removeClass 'loading'

  onChangeMarkCount: =>
    @creatureCounter.html @surface.tools.length

  onClickFinish: ->
    # checks = @checkMark()
    # console.log 'check', checks

    # unless checks.indexOf(undefined) > -1
    # console.log 'all true!'
    sessionClassifications += 1

    @finishButton.attr disabled: true
    @nextButton.attr disabled: false
    @surface.disable()

    @surface.selection?.deselect()

    @classification.annotate tool.mark for tool in @surface.tools

    # TODO: Send classification
    console?.log 'classification send', @classification
    # @classification.send()

    @el.addClass 'finished'

    classificationCount = User.current?.project?.classification_count || 0
    classificationCount += Classification.sentThisSession
    # else
    #   incompleteMarkCount = 0
    #   for check in checks
    #     if check is undefined
    #       incompleteMarkCount++

    #   console.log 'incomplete marks', @marksIncomplete, incompleteMarkCount

  # checkMark: ->
  #   for tool in @surface.tools
  #     do (tool) ->
  #       console.log tool.mark.species
  #       return true if tool.mark.species?

  onClickTutorial: ->
    @slideTutorial.start()

  onClickSignIn: ->
    loginDialog.show()

  onClickFavorite: (e) ->
    @el.addClass 'is-favorite'
    @favorite = new Favorite subjects: [@classification.subject]
    @favorite.on 'delete', @onFavoriteDelete

    @favorite.send()
    @favorite.trigger 'from-classification'

  onFavoriteFromClassify: =>
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
