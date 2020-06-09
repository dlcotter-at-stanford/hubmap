#!/bin/sh

export FLASK_ENV=dev

# I had been using dev.cfg and prd.cfg to control whether the app ran in debug
# mode, but the app doesn't seem to pick up the values from there for some
# reason, so I've moved that part of the configuration into the run script. This
# also lets me control whether the app runs in the foreground (for debugging)
# or the background (for production).

if [[ $FLASK_ENV=dev ]]
then
  export FLASK_CONFIG=../dev.cfg
  export FLASK_DEBUG=True
  python app.py
fi

if [[ $FLASK_ENV=prd ]]
then
  export FLASK_CONFIG=../prd.cfg
  export FLASK_DEBUG=False
  python app.py &
fi

