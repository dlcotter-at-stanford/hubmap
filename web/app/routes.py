from app import app
import database
import flask

@app.route('/')
def index():
  return flask.render_template('index.html'
                              ,title='Colon map visualization'
                              ,subjects=database.Database(app.config).get_subjects_with_mapped_samples())

@app.route('/map/<subject>')
def map(subject):
  db = database.Database(app.config) 

  # If there are no subjects found or the requested subject is not found, redirect:
  subjects = db.get_subjects_with_mapped_samples()
  subject_ids = db.get_results_by_column_name(subjects, 'subject')
  if subjects is None or subject not in subject_ids:
    return flask.redirect('/')

  # Get the data sets to be displayed as tables under the visualization.
  # To add new data set, just add the name and database call here and add the
  # data set to the parameters of render_template(...).
  datasets = { 'clinical' : db.get_samples_with_coordinates(subject)
              ,'pathology': db.get_pathology_by_subject(subject)
              ,**           db.get_all_metadata(subject) }

  # Prune empty data sets (note: list(...) prevents error from modifying dict
  # while iterating over it)
  for ds in list(datasets):
    if not datasets[ds]['data']:
      del datasets[ds]

  return flask.render_template('map.html', title='Samples', subject=subject, tables=datasets, other_subjects=subjects)
