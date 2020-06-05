import os
from flask import Flask

app = Flask(__name__)

if 'FLASK_ENV' in os.environ:
    if os.environ['FLASK_ENV'] == 'dev':
        app.config.from_envvar('FLASK_DEV_CONFIG')
    if os.environ['FLASK_ENV'] == 'prd':
        app.config.from_envvar('FLASK_PRD_CONFIG')

from app import routes

app.run(host='0.0.0.0')
