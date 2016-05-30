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

## Known Issues/Todo

- Update script should run on a cron to periodically update
