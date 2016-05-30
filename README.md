# Strava Prompt Summary

A nodejs module to preappend your bash/zsh liquid prompt with Strava data.


## Dependencies

CoffeeScript
liquidprompt


## Install

```
git clone git@github.com:igniteflow/strava-prompt.git
npm install -g
```

Add the following to your `.bashrc` file

```
export STRAVA_ACCESS_TOKEN="replace-with-your-token"
function _bashPrompt() {
    export LP_PS1_PREFIX="$(stravaprompt $?)" # 2> /dev/null)"
}
export PROMPT_COMMAND="_bashPrompt; $PROMPT_COMMAND"
```

You can now run the command to update your locally stored Strava data with:

`stravaprompt --update`  

If all went well you should see a message telling you the path of the summary data.  Open a new terminal or
source your bashrc file to see the prompt.


## Configuration

`NUM_DAYS` (defaults to 7) determines the number of days in the past to collect activity data for

## Customisation

`bashPromptPrefix` prints the prompt prefix to STDOUT.  Feel free to customise this however you want.  The Strava summary object looks like:

```
{
  "totalDistance": 10047.400000000001,
  "totalMovingTime": 2675,
  "totalElevationGain": 63.9,
  "totalKudos": 3,
  "totalAchievements": 5,
  "averageSpeed": 3.593,
  "maxSpeed": 5.9
}
```

## Developing

The process is split into two stages.  I've incuded the compile commands below for easier debugging:

1. fetch the data from the Strava API and write a summary of it to file  `coffee --compile --bare --no-header -o ./bin stravaprompt.coffee && node bin/stravaprompt.js --update`

2. print the prompt prefix to STDOUT `coffee --compile --bare --no-header -o ./bin stravaprompt.coffee && node bin/stravaprompt.js`.  Note that this is called in `~/.bashrc|zshrc`.


## Known Issues/Todo

- Update script should run on a cron to periodically update
- I've submitted a pull request to `strava-v3` to fix a bug in `activities.get()`, until this is merged the changes will have to be made manually
