wait = (delay, fn) ->
  setTimeout fn, delay

class Counter
  duration: 2000
  fps: 20
  el: null

  constructor: (params = {}) ->
    @[property] = value for property, value of params
    @el ?= document.createElement 'span'
    @el = @el.get 0 if 'get' of @el

  set: (value) ->
    original = parseFloat(@el.innerHTML.replace /[^\d]/g, '') || 0

    flips = Math.floor @duration / (1000 / @fps)
    delay = @duration / flips

    for i in [0...flips] then do (i) =>
      wait delay * i, =>
        step = Math.floor original + ((value - original) * (i / flips))
        step = '\u2014' if isNaN step
        @el.innerHTML = step

    wait @duration + delay, =>
      @el.innerHTML = value

module.exports = Counter
