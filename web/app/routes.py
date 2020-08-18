from app import app
import database
import flask
import pdb

@app.route('/')
def landing():
  flask.redirect('/map')
  # eventually we'll want a real landing page

@app.route('/map/<subject_id>')
def map(subject_id=None):
  # Initialize database context and get list of subjects with mapped samples
  db = database.Database(app.config) 
  subjects = db.get_subjects( { 'study'          : 'HuBMAP',  # hardcoding for now
                                'has_coordinates': True },
                              { 'friendly_names' : False } )

  # Render landing page with subjects listed if no subject specified
  if not subject_id:
    return flask.render_template('index.html', title='Landing Page', subjects=subjects)

  # Redirect if no matching subjects found:
  subject_ids = [ subject['subject_bk'] for subject in subjects ]
  if subject_id not in subject_ids:
    return flask.redirect('/map')

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

