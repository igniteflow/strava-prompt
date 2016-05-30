# Strava Prompt Summary

A nodejs module to preappend your bash/zsh liquid prompt with Strava data.


## Dependencies

CoffeeScript
liquidprompt


## Install

Follow the instructions at https://www.npmjs.com/package/strava-v3 to get your Strava access token [FIXME: config data needs to be moved to a config file]

```
git clone git@github.com:igniteflow/strava-prompt.git
npm install -g
```

Add the following to your `.bashrc` file

```
function _bashPrompt() {
    export LP_PS1_PREFIX="$(stravaprompt $?)" # 2> /dev/null)"
}
export PROMPT_COMMAND="_bashPrompt; $PROMPT_COMMAND"
```

## Developing

The process is split into two stages.  I've incuded the compile commands below for easier debugging:

1. fetch the data from the Strava API and write a summary of it to file  `coffee --compile --bare --no-header -o ./bin stravaprompt.coffee && node bin/stravaprompt.js --update`

2. print the prompt prefix to STDOUT `coffee --compile --bare --no-header -o ./bin stravaprompt.coffee && node bin/stravaprompt.js`.  Note that this is called in `~/.bashrc|zshrc`.


## Known Issues/Todo

- Update script should run on a cron to periodically update
- Global install is currently failing on installing the `bin/` script
