{Controller} = require 'spine'
template = require '../views/stats'

class Stats extends Controller
  className: 'stats'

  elements:
    '#user-count': 'userCountEl'
    '#percent-complete': 'completeEl'
    '#total-images': 'totalImagesEl'
    '#classification-count': 'classificationCountEl'

  constructor: ->
    super
    @html template

  percentComplete: ->
    return 0 unless @subjectCount
    @completeCount = Math.floor(@completeCount / @subjectCount * 100)

  updateTemplate: ->
    @userCountEl.html @userCount
    @classificationCountEl.html @classificationCount
    @totalImagesEl.html @subjectCount
    @completeEl.html @completeCount + "%"

module.exports = Stats
