{spawn} = require 'child_process'

run = (fullCommand) ->
  [command, args...] = fullCommand.split /\s+/
  child = spawn command, args
  child.stdout.on 'data', process.stdout.write.bind process.stdout
  child.stderr.on 'data', process.stderr.write.bind process.stderr

task 'build-icon-font', 'Regenerate the custom icon font', ->
  run 'fontcustom compile --debug --font_path ./ --output ./public/fonts/fontcustom ./icons'
