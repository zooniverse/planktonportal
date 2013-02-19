require 'json2ify'
require 'es5-shimify'

# Order is importnat here:
require 'jqueryify'
require 'spine'
require 'spine/lib/route'
require 'spine/lib/manager'

translate = require 'translate'
enUs = require './en-us'
translate.load enUs
