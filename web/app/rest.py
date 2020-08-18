from app import app
import database
import flask
import pdb

### REST API ###
@app.route("/api/")
@app.route("/api/studies")
def studies():
  db = database.Database(app.config) 
  studies = db.get_studies(result_prefs = { "stringify": True })
 
  return flask.jsonify(studies)

# maybe there should be a route like <study>/<subject>/<sample> for convenience

@app.route("/api/<study>/")
@app.route("/api/studies/<study>/")
@app.route("/api/studies/<study>/subjects")
def subjects(study):
  db = database.Database(app.config) 
  subjects = db.get_subjects(query_args   = { "study": study.lower() }
                            ,result_prefs = { "stringify": True })
 
  return flask.jsonify(subjects)

@app.route("/api/<study>/<subject>/", methods = ["GET", "POST"])
@app.route("/api/<study>/subjects/<subject>/", methods = ["GET", "POST"])
@app.route("/api/studies/<study>/subjects/<subject>", methods = ["GET", "POST"])
def samples(study, subject):
  db = database.Database(app.config) 
  samples = db.get_samples(query_args   = { "study"    : study.lower()
                                          , "subject"  : subject.lower() }
                          ,result_prefs = { "stringify": True })
 
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
