Page = require './page'
template = require '../views/classify'
translate = require 't7e'
MarkingSurface = require 'marking-surface'
PlanktonTool = require './plankton-tool'
User = require 'zooniverse/models/user'
Subject = require 'zooniverse/models/subject'

class Classify extends Page
  className: 'classify'

  surface: null

  events:
    'click button[name="finish"]': 'onClickFinish'
    'click button[name="favorite"]': 'onClickFavorite'
    'click button[name="next"]': 'onClickNext'

  constructor: ->
    super
    @html template
    @el.addClass 'loading'

    @surface ?= new MarkingSurface
      tool: PlanktonTool
      container: @el.find '.subject'
      width: 1024
      height: 562

    @surface.on 'create-mark', @onCreateMark

    User.on 'change', @onUserChange
    Subject.on 'get-next', @onGettingNextSubject
    Subject.on 'select', @onSubjectSelect
    Subject.on 'no-more', @onNoMoreSubjects

  onUserChange: =>

  onGettingNextSubject: =>
    @el.addClass 'loading'

  onSubjectSelect: =>
    @el.removeClass 'loading'

  onNoMoreSubjects: =>
    @el.removeClass 'loading'

  onCreateMark: =>

  onClickFinish: ->

  onClickFavorite: ->

  onClickNext: ->

module.exports = Classify
