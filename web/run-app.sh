#!/bin/zsh

# Remember to set the FLASK_ENV environment variable to either "dev" or "prd".
# I was setting it in this script but took it out so that it wouldn't appear
# to be constantly fluctuating in source commits.

# I had been using dev.cfg and prd.cfg to control whether the app ran in debug
# mode, but the app doesn't seem to pick up the values from there for some
# reason, so I've moved that part of the configuration into the run script. This
# also lets me control whether the app runs in the foreground (for debugging)
# or the background (for production).

if [ "$FLASK_ENV" = "dev" ]; then
  export FLASK_CONFIG=../dev.cfg  # .. because this is running in ./app
  export FLASK_DEBUG=True
  python app.py
fi

if [ "$FLASK_ENV" = "prd" ]; then
  export FLASK_CONFIG=../prd.cfg  # .. because this is running in ./app
  export FLASK_DEBUG=False
  # kill the existing process if the app is already running (suppress help message if not)
  ps aux | grep -E "python app\.py$" | tr -s ' ' | cut -d' ' -f2 | xargs kill 2>/dev/null
  # run the app in the background
  python app.py &
fi

