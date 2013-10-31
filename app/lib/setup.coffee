require 'json2ify'
require 'es5-shimify'

# Order is important here:
require 'jqueryify'
require 'spine'
require 'spine/lib/route'
require 'spine/lib/manager'

translate = require 't7e'
if localStorage['plankton-languageStrings']
  languageStrings = JSON.parse localStorage['plankton-languageStrings']
else
  languageStrings = require './en-us'

translate.load languageStrings

# Editor = require 't7e/editor'
# if (!!~location.search.indexOf 'translate')
#   Editor.init()
