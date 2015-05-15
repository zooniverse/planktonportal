Subject = require 'zooniverse/models/subject'

TODO_ID = '51d481c43ae740cf60000001'
TODO_ZOONIVERSE_ID = 'APK000005n'

createTutorialSubject = (index = 0) ->
  [id, zooniverseId, location] = switch index
    when 0 then ['51d481c43ae740cf60000001', 'APK0000001', './images/training-subject-1.jpg']
    when 1 then ['52408e8b3ae7400578000001', 'APK00078uj', './images/training-subject-2.jpg']
    when 2 then ['52408e8b3ae7400578000002', 'APK00078uk', './images/training-subject-3.jpg']

  new Subject
    id: id
    zooniverse_id: zooniverseId

    location: standard: location

    coords: [0, 0]

    metadata: {
      tutorial: true if index is 0
      training: index if index > 0
      file_name: 'TUTORIAL_SUBJECT'
      depth: 0
      temp: 0
    }
    workflow_ids: ['516d6f243ae740bc96000002']

module.exports = createTutorialSubject
