`#! /usr/bin/env node
`
###
Writes the bash prompt prefix to STDOUT.  This script is executed in .bashrc by adding:

function _bashPrompt() {
    export LP_PS1_PREFIX="$(stravaprompt $?)" # 2> /dev/null)"
}
export PROMPT_COMMAND="_bashPrompt; $PROMPT_COMMAND"

compile with: coffee --compile --bare --no-header run.coffee -o ./bin/strava-prompt.js
see https://coderwall.com/p/k1n70a/compiling-executables-from-coffeescript
###

jsonfile = require 'jsonfile'
os = require 'os'
path = require 'path'
colorStdout = require('color-stdout');

# FIXME: this is also defined in strava.coffee, move to one place
stravaSummmaryFile = path.join(os.homedir(), '.strava_data.json')

# util function to format metres and km to two decimal places
metresToKm = (m) -> (m / 1000).toFixed(2)

# modify the return value to customise your bash prompt
# IMPORTANT - this function must print to STDOUT.  Any returned value from the
# function will be ignored
bashPromptPrefix = (obj) -> colorStdout.green metresToKm(obj.totalDistance)

# read the summary file and update
jsonfile.readFile(
    stravaSummmaryFile,
    (err, obj) -> bashPromptPrefix(obj)
)
