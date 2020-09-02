from app import app
import database
import flask
import json
import pdb

"""
REST API actions:
    POST for creating new requirements
    GET for getting the requirements
    PUT (or PATCH) for updating them

The most common response codes used by APIs include:
    200 OK – the API request succeeded (general purpose)
    201 Created – request to create a new record succeeded
    204 No Content – the API request succeeded, but there is no response payload to return
    400 Bad Request – the API request is bad or malformed and could not be processed by the server
    404 Not Found – couldn’t find a record by ID
"""

def rest_endpoint(func):
  def wrapper(*args, **kwargs):
    db = database.Database(app.config) 

    if flask.request.method == 'GET':
      entity = func(db, *args, **kwargs)
      return flask.jsonify(entity)

    if flask.request.method == 'POST':
      # check that the request is json
      if not flask.request.is_json:
        return flask.make_response(('Request missing header Content-Type: application/json', 404))

      # check that the request is not empty
      if not flask.request.data:
        return flask.make_response(('No data found in POST request', 404))
       
      # try decoding the payload
      try:
        data_decoded = flask.request.data.decode()
      except EncodeError as e:
        error_msg = e.__class__.__name__ + ": " + str(e)
        return flask.make_response((error_msg, 404))

      # load as json
      try:
        json_loaded = flask.json.loads(data_decoded)
      except json.JSONDecodeError as e:
        error_msg = e.__class__.__name__ + ": " + str(e)
        return flask.make_response((error_msg, 404))

      # translate route parameters into database parameters
      if 'study' in json_loaded:
        json_loaded['p_study_bk'] = json_loaded.pop('study')
      if 'subject' in json_loaded:
        json_loaded['p_subject_bk'] = json_loaded.pop('subject')

      entity = func(db, json_loaded, *args, **kwargs)
      return flask.jsonify(entity)

  # change the function name so we don't get overlapping views
  wrapper.__name__ = func.__name__

  return wrapper

### REST API ###
@app.route("/api/docs")

@app.route("/api/")
@app.route("/api/studies/")
@rest_endpoint
def get_studies(db):
  return db.do( operation = "get"
              , entity = "studies"
              , result_prefs = { "stringify": True })

@app.route("/api/studies/", methods = ["POST"])
@rest_endpoint
def post_studies(db, json_input):
  return db.do( operation = "put"
              , entity = "study"
              , query_args = json_input )

@app.route("/api/studies/<study>/subjects/")
@rest_endpoint
def get_subjects(db, study):
  return db.do( operation = "get"
              , entity = "subjects"
              , query_args = { "p_study_bk": study.lower() }
              , result_prefs = { "stringify": True })

@app.route("/api/studies/<study>/subjects/", methods = ["POST"])
@rest_endpoint
def post_subjects(db, json_input, study):
  if 'p_study_bk' in json_input and study != json_input['p_study_bk']:
    raise ValueError("Value of 'study' in URL and JSON payload do not agree.")

  if 'p_study_bk' not in json_input:
    raise ValueError("Parent study of sample must be included in JSON payload.")

  return db.do( operation = "put"
              , entity = "subject"
              , query_args = json_input )

@app.route("/api/studies/<study>/subjects/<subject>/samples/")
@rest_endpoint
def get_samples(db, study, subject):
  return db.do( operation = "get"
              , entity = "samples"
              , query_args = { "p_study_bk": study.lower(), "p_subject_bk": subject.lower() }
              , result_prefs = { "stringify": True })

@app.route("/api/studies/<study>/subjects/<subject>/samples/", methods = ["POST"])
@rest_endpoint
def post_samples(db, study, subject):
  # should we check that study & subject params match what's in the JSON?
  return db.do( operation = "put"
              , entity = "sample"
              , query_args = json_input
              , result_prefs = { "stringify": True })

friendly_names = \
  { 'subject_bk' : 'subject'
  , 'sample_bk'  : 'sample name'
  , 'size_length': 'length'
  , 'size_width' : 'width'
  , 'size_depth' : 'depth'
  , 'x_coord'    : 'x'
  , 'y_coord'    : 'y'
  , 'organ_piece': 'location'
  , 'attr'       : 'attribute' }

## convert cryptic/technical column names to user-friendly equivalents
#if _result_prefs['friendly_names']:
#  header = [ self.friendly_names[col] if col in self.friendly_names else col.replace('_',' ') for col in header ]



