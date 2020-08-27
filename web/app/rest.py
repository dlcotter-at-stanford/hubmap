from app import app
import database
import flask
import json
import pdb

### REST API ###
@app.route("/api/")  # maybe this should take them to docs

@app.route("/api/studies", methods = ["GET", "POST"])
def studies():
  db = database.Database(app.config) 

  if flask.request.method == 'GET':
    studies = db.do('get', 'studies', result_prefs = { "stringify": True })
    return flask.jsonify(studies)

  if flask.request.method == 'POST':
    # check that the request is json
    if not flask.request.is_json:
      return flask.make_response(('Request missing header Content-Type: application/json', 404))

    if not flask.request.data:
      return flask.make_response(('No data found in POST request', 404))
     
    # try decoding it
    try:
      _data_decoded = flask.request.data.decode()
    except EncodeError as e:
      error_msg = e.__class__.__name__ + ": " + str(e)
      return flask.make_response((error_msg, 404))

    # load as json
    try:
      _json_loaded = flask.json.loads(_data_decoded)
    except json.JSONDecodeError as e:
      error_msg = e.__class__.__name__ + ": " + str(e)
      return flask.make_response((error_msg, 404))

    # translate route parameters into database parameters
    if 'study' in _json_loaded:
      _json_loaded['p_study_bk'] = _json_loaded.pop('study')

    # do database insert
    study = db.do('put', 'study', query_args = _json_loaded)

    return flask.jsonify(study)

@app.route("/api/<study>/")
@app.route("/api/studies/<study>/")
@app.route("/api/studies/<study>/subjects")
def subjects(study):
  db = database.Database(app.config) 
  subjects = db.do( operation = "get"
                  , entity = "subjects"
                  , query_args = { "p_study_bk": study.lower() }
                  , result_prefs = { "stringify": True })
 
  return flask.jsonify(subjects)

@app.route("/api/<study>/<subject>/", methods = ["GET", "POST"])
@app.route("/api/<study>/subjects/<subject>/", methods = ["GET", "POST"])
@app.route("/api/studies/<study>/subjects/<subject>", methods = ["GET", "POST"])
def samples(study, subject):
  db = database.Database(app.config) 
  samples = db.do( operation = "get"
                 , entity = "samples"
                 , query_args = { "p_study_bk": study.lower()
                                , "p_subject_bk": subject.lower() }
                 , result_prefs = { "stringify": True })
 
  return flask.jsonify(samples)

"""
    POST for creating new requirements

    GET for getting the requirements

    PUT (or PATCH) for updating them

    DELETE for deleting them


The most common response codes used by APIs include:

    200 OK – the API request succeeded (general purpose)
    201 Created – request to create a new record succeeded
    204 No Content – the API request succeeded, but there is no response payload to return
    400 Bad Request – the API request is bad or malformed and could not be processed by the server
    404 Not Found – couldn’t find a record by ID

Advantages of REST API
* does not require a GUI, but allows for one (or many, e.g. a mobile app, a web app, a desktop app, etc.)
* language agnostic, so researchers can create/read/update/delete from Python, R, etc.
* provides layer between user and database to handle authentication, data validation, schema mapping, etc.
* allows changes to data model without changing API
* could implement project-level security (so e.g. a researcher could only access HuBMAP data)
* limits access to database were the web server to be hacked
* provides access for Ajax queries
"""
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

