Page = require './page'
template = require '../views/classify'
translate = require 't7e'
MarkingSurface = require 'marking-surface'
PlanktonTool = require './plankton-tool'
User = require 'zooniverse/models/user'
Subject = require 'zooniverse/models/subject'

class Classify extends Page
  className: 'classify'

  events:
    'click button[name="finish"]': 'onClickFinish'
    'click button[name="favorite"]': 'onClickFavorite'
    'click button[name="next"]': 'onClickNext'

  constructor: ->
    super
    @html template
    @el.addClass 'loading'

    User.on 'change', @onUserChange
    Subject.on 'get-next', @onGettingNextSubject
    Subject.on 'select', @onSubjectSelect
    Subject.on 'no-more', @onNoMoreSubjects

  onUserChange: ->

  onGettingNextSubject: ->

  onSubjectSelect: ->

  onNoMoreSubjects: ->

  onClickFinish: ->

  onClickFavorite: ->

  onClickNext: ->

module.exports = Classify
