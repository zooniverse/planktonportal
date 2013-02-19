require 'json2ify'
require 'es5-shimify'

# Order is importnat here:
$ = require 'jqueryify'
{Controller} = require 'spine'
Route = require 'spine/lib/route'
{Stack} = require 'spine/lib/manager'

stack = new Stack
  controllers:
    home: class extends Controller then constructor: -> super; @html 'Home'
    classify: class extends Controller then constructor: -> super; @html 'Classify'
    profile: class extends Controller then constructor: -> super; @html 'Profile'

  routes:
    '/': 'home'
    '/classify': 'classify'
    '/profile': 'profile'

  default: 'home'

stack.el.appendTo document.body
Route.setup()

module.exports = {stack}
