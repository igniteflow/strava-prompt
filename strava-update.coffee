###
Reads Strava API data and writes a summary of it to a file
###

jsonfile = require 'jsonfile'
moment = require 'moment'
os = require 'os'
path = require 'path'
strava = require 'strava-v3'

###
config
###

# number of days for which to fetch activites
NUM_DAYS = 2

# file to write the Strava activity summary data to
OUTPUT_FILE = path.join(os.homedir(), '.strava_data.json')

###
utils
###

sum = (array) ->
    array.reduce (x, y) -> x + y

sumActivityValue = (array, value) ->
    sum((a[value] for a in array))

# support ES5.  In ES6 we can use: `Math.max array`
max = (array) -> array.reduce (a, b) -> Math.max a, b

###
Strava summary constructor
###

# get activities from the last n days
start = moment().subtract(NUM_DAYS, 'days')
params =
    after: start.unix()

# fetch strava activities and write them to a file
callback = (error, payload) ->

    # as the params.after filter is not filtering the activities, then we do it manually
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
    writeFileError = (err) -> console.log err
    jsonfile.writeFile(OUTPUT_FILE, activitySummary, {spaces: 2}, writeFileError)

    console.log 'Strava summary written to {OUTPUT_FILE}'

strava.activities.get(params, callback)
