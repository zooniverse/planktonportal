Subject = require 'zooniverse/models/subject'

createTutorialSubject = ->
  new Subject
    id: '51d481c43ae740cf60000001'
    zooniverse_id: 'APK000005n'

    location: standard: './images/tutorial-subject.jpg'

    coords: [0, 0]

    metadata:
      tutorial: true
      file_name: 'TUTORIAL_SUBJECT'
      depth: 0
      temp: 0

    workflow_ids: ['516d6f243ae740bc96000002']

module.exports = createTutorialSubject
