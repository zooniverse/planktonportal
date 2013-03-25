{Stack} = require 'spine/lib/manager'
Page = require './page'
translate = require 't7e'

class Science extends Stack
  className: "science #{Stack::className}"

  controllers:
    plankton: class extends Page then content: translate {div: 'science.plankton.content'}
    whyStudy: class extends Page then content: translate {div: 'science.whyStudy.content'}
    images: class extends Page then content: translate {div: 'science.images.content'}
    species: class extends Page then content: """
      #{translate  p: 'science.species.content'}
      #{translate h2: 'science.species.jellies.title'}
      #{translate  p: 'science.species.jellies.content'}
      #{translate h3: 'science.species.jellies.scyphozoa.title'}
      #{translate  p: 'science.species.jellies.scyphozoa.content'}
      #{translate h3: 'science.species.jellies.hydromedusae.title'}
      #{translate  p: 'science.species.jellies.hydromedusae.content'}
      #{translate h3: 'science.species.jellies.solmaris.title'}
      #{translate  p: 'science.species.jellies.solmaris.content'}
      #{translate h3: 'science.species.jellies.siphonophores.title'}
      #{translate  p: 'science.species.jellies.siphonophores.content'}
      #{translate h3: 'science.species.jellies.ctenophores.title'}
      #{translate  p: 'science.species.jellies.ctenophores.content'}
      #{translate h3: 'science.species.pelagicTunicates.title'}
      #{translate  p: 'science.species.pelagicTunicates.content'}
      #{translate h3: 'science.species.pelagicTunicates.salpsAndDoliolids.title'}
      #{translate  p: 'science.species.pelagicTunicates.salpsAndDoliolids.content'}
      #{translate h3: 'science.species.pelagicTunicates.larvaceans.title'}
      #{translate  p: 'science.species.pelagicTunicates.larvaceans.content'}
      #{translate h2: 'science.species.other.title'}
      #{translate h3: 'science.species.other.copepods.title'}
      #{translate  p: 'science.species.other.copepods.content'}
      #{translate h3: 'science.species.other.shrimp.title'}
      #{translate  p: 'science.species.other.shrimp.content'}
      #{translate h3: 'science.species.other.chaetognaths.title'}
      #{translate  p: 'science.species.other.chaetognaths.content'}
      #{translate h3: 'science.species.other.pteropods.title'}
      #{translate  p: 'science.species.other.pteropods.content'}
      #{translate h3: 'science.species.other.polychaetes.title'}
      #{translate  p: 'science.species.other.polychaetes.content'}
      #{translate h3: 'science.species.other.radiolarian.title'}
      #{translate  p: 'science.species.other.radiolarian.content'}
    """

  navLinks:
    plankton: translate {span: 'science.plankton.title'}
    whyStudy: translate {span: 'science.whyStudy.title'}
    images: translate {span: 'science.images.title'}
    species: translate {span: 'science.species.title'}

  routes:
    '/science/plankton': 'plankton'
    '/science/whyStudy': 'whyStudy'
    '/science/images': 'images'
    '/science/species': 'species'

  default: 'plankton'

  constructor: ->
    super

    nav = $('<nav></nav>')

    reverseRoutes = {}
    reverseRoutes[controller] = route for route, controller of @routes

    for controller, text of @navLinks
      nav.append "<a href='##{reverseRoutes[controller]}'>#{text}</a>"

    @el.prepend nav

module.exports = Science
