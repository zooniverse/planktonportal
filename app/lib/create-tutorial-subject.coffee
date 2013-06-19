Subject = require 'zooniverse/models/subject'

createTutorialSubject = ->
  new Subject
    id: '516d6f243ae740bc96000567'
    zooniverse_id: 'TUTORIAL_SUBJECT'

    location: standard: './images/tutorial-subject.jpg'

    coords: [0, 0]

    metadata:
      tutorial: true
      file_name: 'TUTORIAL_SUBJECT'
      depth: 0
      temp: 0

    workflow_ids: ['TODO']

module.exports = createTutorialSubject
