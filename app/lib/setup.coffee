require 'json2ify'
require 'es5-shimify'

# Order is important here:
require 'jqueryify'
require 'spine'
require 'spine/lib/route'
require 'spine/lib/manager'

translate = require 't7e'
enUs = require './en-us'
translate.load enUs

# Editor = require 't7e/editor'
# if (!!~location.search.indexOf 'translate')
#   Editor.init()
