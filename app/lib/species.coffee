Subject = require 'zooniverse/models/subject'

species =
  order: ['round', 'tail', 'tentacled', 'worm', 'bug']

  original:
    round: ['lobate', 'larvaceanHouse', 'salp', 'thalasso', 'doliolidWithoutTail']
    tail: ['rocketThimble', 'rocketTriangle', 'siphoCornCob', 'siphoTwoCups', 'doliolidWithTail']
    tentacled: ['cydippid', 'solmaris', 'medusaFourTentacles', 'medusaMoreThanFourTentacles', 'medusaGoblet']
    worm: ['beroida', 'cestida', 'radiolarianColonies', 'larvacean', 'arrowWorm']
    bug: ['shrimp', 'polychaeteWorm', 'copepod']

  mediterranean:
    round: ['larvaceanHouse', 'doliolidWithoutTail', 'radiolarianDark']
    tail: ['rocketThimble', 'rocketTriangle', 'siphoCornCob', 'siphoTwoCups', 'doliolidWithTail']
    tentacled: ['cydippid', 'solmaris', 'medusaMoreThanFourTentacles', 'medusaGoblet', 'medusaEphyrae']
    worm: ['radiolarianColonies', 'larvacean', 'arrowWorm', 'fishLarvae']
    bug: ['shrimp', 'polychaeteWorm', 'copepod', 'pteropods']

  fieldGuide:
    round: ['lobate', 'larvaceanHouse', 'salp', 'thalasso', 'doliolidWithoutTail', 'radiolarianDark']
    tail: ['rocketThimble', 'rocketTriangle', 'siphoCornCob', 'siphoTwoCups', 'doliolidWithTail']
    tentacled: ['cydippid', 'solmaris', 'medusaFourTentacles', 'medusaMoreThanFourTentacles', 'medusaGoblet', 'medusaEphyrae']
    worm: ['beroida', 'cestida', 'radiolarianColonies', 'larvacean', 'arrowWorm', 'fishLarvae']
    bug: ['shrimp', 'polychaeteWorm', 'copepod', 'pteropods']


module.exports = species
