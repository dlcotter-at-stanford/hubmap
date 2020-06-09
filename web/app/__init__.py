import os
import waitress
import flask

app = flask.Flask(__name__)

from app import routes

if 'FLASK_CONFIG' in os.environ:
  app.config.from_envvar('FLASK_CONFIG')

if 'FLASK_ENV' in os.environ:
  if os.environ['FLASK_ENV'] == 'dev':
    app.run()
  if os.environ['FLASK_ENV'] == 'prd':
    waitress.serve(app, host='0.0.0.0', port=5000)
