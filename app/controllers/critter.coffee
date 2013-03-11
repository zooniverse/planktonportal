$ = window.jQuery

class Critter
  @instances: []

  $(window).on 'scroll', =>
    instance.onScroll arguments... for instance in @instances

  className: ''
  image: ''

  el: null

  constructor: (params = {}) ->
    @[property] = value for property, value of params

    @el ?= $("<img class='#{@className} critter' src='#{@image}' />")

    @constructor.instances.push @

  onScroll: ->
    scrolled = scrollY / scrollMaxY

    @el.css
      'margin-top': -100 * scrolled
      opacity: (1 - scrolled) + 0.33

module.exports = Critter
