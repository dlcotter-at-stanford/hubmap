#!/bin/sh
export FLASK_PRD_CONFIG=../prd.cfg
export FLASK_DEV_CONFIG=../dev.cfg
export FLASK_ENV=dev

python /home/dlcott2/hubmap/web/app.py &
