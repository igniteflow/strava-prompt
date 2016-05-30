`#! /usr/bin/env node
`
###
Writes the bash prompt prefix to STDOUT.  This script is executed in .bashrc by adding:

function _bashPrompt() {
    export LP_PS1_PREFIX="$(stravaprompt $?)" # 2> /dev/null)"
}
export PROMPT_COMMAND="_bashPrompt; $PROMPT_COMMAND"
###

colorStdout = require 'color-stdout'
jsonfile = require 'jsonfile'
minimist = require 'minimist'
moment = require 'moment'
os = require 'os'
path = require 'path'
strava = require 'strava-v3'

###
config
###

# number of days for which to fetch activites
NUM_DAYS = 7

# file to write the Strava activity summary data to
SUMMARY_FILE = path.join(os.homedir(), '.strava_data.json')


###
utility functions
###

sum = (array) ->
    array.reduce (x, y) -> x + y

sumActivityValue = (array, value) ->
    sum((a[value] for a in array))

# support ES5.  In ES6 we can use: `Math.max array`
max = (array) -> array.reduce (a, b) -> Math.max a, b

# util function to format metres and km to two decimal places
metresToKm = (m) -> (m / 1000).toFixed(2)


bashPromptPrefix = (obj) ->
    ###
    modify the return value to customise your bash prompt
    IMPORTANT - this function must print to STDOUT.  Any returned value from the
    function will be ignored

    Example object format:

    {
      "totalDistance": 10047.400000000001,
      "totalMovingTime": 2675,
      "totalElevationGain": 63.9,
      "totalKudos": 3,
      "totalAchievements": 5,
      "averageSpeed": 3.593,
      "maxSpeed": 5.9
    }

    ###
    km = metresToKm(obj.totalDistance)
    colorStdout.green "[#{km}km] "

# read the summary file and update
printToStdOut = () ->
    jsonfile.readFile(
        SUMMARY_FILE,
        (err, obj) -> bashPromptPrefix(obj)
    )


update = () ->
    # get activities from the last n days
    start = moment().subtract(NUM_DAYS, 'days')
    params =
        after: start.unix()

    # fetch strava activities and write them to a file
    callback = (error, payload) ->

        if error
            console.log err

        # as the params.after filter is not filtering the activities (appears to be a bug in strava-v3)
        # so we do it manually
        activities = (act for act in payload when moment(act.start_date).isSameOrAfter(start))

        activitySummary =
            totalDistance: sumActivityValue(activities, 'distance')
            totalMovingTime: sumActivityValue(activities, 'moving_time')
            totalElevationGain: sumActivityValue(activities, 'total_elevation_gain')
            totalKudos: sumActivityValue(activities, 'kudos_count')
            totalAchievements: sumActivityValue(activities, 'achievement_count')
            averageSpeed: sumActivityValue(activities, 'average_speed') / activities.length
            maxSpeed: max (a.max_speed for a in activities)

        # write the activities to a file
        writeFileError = (err) ->
            if err
                console.log err

        jsonfile.writeFile(SUMMARY_FILE, activitySummary, {spaces: 2}, writeFileError)

        console.log "Strava summary written to #{SUMMARY_FILE}"

    strava.activities.get(params, callback)


# parse command line args and execute
argv = minimist process.argv.slice(2)

if 'update' of argv
    update()
else
    printToStdOut()
