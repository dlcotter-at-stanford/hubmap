from app import app
import database
import flask
import pdb

@app.route('/')  # eventually we'll want a real landing page
@app.route('/<subject_id>')  # eventually this should be '/map/<subject_id>'
def map(subject_id=None):
  # Initialize database context and get list of subjects with mapped samples
  db = database.Database(app.config) 
  subjects = db.get_subjects( { 'study': 'HuBMAP',  # hardcoding for now
                                'has_coordinates': True },
                              { 'friendly_names': False } )

  # Render landing page with subjects listed if no subject specified
  if not subject_id:
    return flask.render_template('index.html', title='Landing Page', subjects=subjects)

  # Redirect if no matching subjects found:
  subject_ids = [ subject['subject_bk'] for subject in subjects ]
  if subject_id not in subject_ids:
    return flask.redirect('/')

  # Get the data sets to be displayed as tables under the visualization.
  # To add new data set, just add the name and database call here and add the
  # data set to the parameters of render_template(...).
  datasets = { 'clinical' : db.get_samples          ( { 'subject': subject_id, 'has_coordinates': True },
                                                      { 'friendly_names': False, 'to_dataset': True } )
              ,'pathology': db.get_pathology_reports( { 'subject': subject_id },
                                                      { 'friendly_names': False, 'to_dataset': True } )
              ,**           db.get_all_metadata     ( { 'subject': subject_id },
                                                      { 'friendly_names': False, 'to_dataset': True } ) }

  # Prune empty data sets (note: list(...) prevents error from modifying dict
  # while iterating over it)
  for ds in list(datasets):
    if not datasets[ds]['data']:
      del datasets[ds]
  #breakpoint()
  return flask.render_template('index.html', title='Samples', subject_id=subject_id, subjects=subjects, tables=datasets)

### REST API ###
@app.route('/studies')
def studies():
  db = database.Database(app.config) 
  studies = db.get_studies(result_prefs = { 'stringify': True })
 
  return flask.jsonify(studies)

@app.route('/subjects')
def subjects():
  db = database.Database(app.config) 
  subjects = db.get_subjects(result_prefs = { 'stringify': True })
 
  return flask.jsonify(subjects)

@app.route('/samples')
def samples():
  db = database.Database(app.config) 
  samples = db.get_samples(result_prefs = { 'stringify': True })
 
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
