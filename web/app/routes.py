from app import app
from database import Database
from flask import render_template, send_from_directory

@app.route('/')
def index():
  subjects = Database(app.config).get_subjects_with_mapped_samples()

  return render_template('index.html', title='Colon map visualization', subjects=subjects)

@app.route('/map/<subject>')
def map(subject):
  datasets = { 'clinical' : Database(app.config).get_samples_with_coordinates(subject)
              ,'pathology': Database(app.config).get_pathology_by_subject(subject) }
  # to add new data set, just add the name and database call here and
  # add the data set to the parameters of render_template(...)

  tables = {}
  for name, dataset in datasets.items():
    if dataset['data'] == []:
      continue
    tables[name] = {}
    tables[name]['header'] = friendly_names(dataset['header'])
    tables[name]['data'] = dataset['data']

  return render_template('map.html', title='Samples', subject=subject, tables=tables)

def friendly_names(header):
  """ Purpose:  Translate internal database column names into more user-friendly equivalents
      Workings: The translation table is intended to function as a first pass for variable names
                whose user-friendly name is not amenable to an generalized algorithmic transformation.
                For those whose database column names are the same as their user friendly names but
                for an underscore, which is many, the substitution is done in the else clause of the
                list comprehension.
  """
  if not header:
    return []

  translation_table = { 'subject_bk' : 'subject'
                       ,'sample_bk'  : 'sample name'
                       ,'size_length': 'length'
                       ,'size_width' : 'width'
                       ,'size_depth' : 'depth'
                       ,'x_coord'    : 'x'
                       ,'y_coord'    : 'y'
                       ,'organ_piece': 'location'
                       ,'attr'       : 'attribute'}
  
  return [ translation_table[col] if col in translation_table else col.replace('_',' ') for col in header ]

"""
Pie chart showing data size of different assays on HuBMAP data
Validation tool (researchers upload data, validation script runs and spits out problems)
"""
