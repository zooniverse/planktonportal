Subject = require 'zooniverse/models/subject'

createTutorialSubject = ->
  new Subject
    id: 'TODO'
    zooniverse_id: 'TUTORIAL_SUBJECT'

    location: standard: '//placehold.it/640x480.png'

    coords: [0, 0]

    metadata:
      tutorial: true
      file_name: 'TUTORIAL_SUBJECT'

    workflow_ids: ['TODO']

module.exports = createTutorialSubject
