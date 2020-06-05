from app import app
from database import Database
from flask import render_template, send_from_directory

@app.route('/')
def index():
  subjects = Database(app.config).get_subjects_with_mapped_samples()

  return render_template('index.html', title='Colon map visualization', subjects=subjects)

@app.route('/map/<subject>')
def map(subject):
  tables = {}

  tables['clinical'] = {}
  tables['clinical']['data'] = Database(app.config).get_samples_with_coordinates(subject)
  tables['clinical']['header'] = friendly_names(tables['clinical']['data'])

  tables['pathology'] = {}
  tables['pathology']['data'] = Database(app.config).get_pathology_by_subject('A001')#subject)
  tables['pathology']['header'] = friendly_names(tables['pathology']['data'])

  # new data set:
  # tables['xxx'] = {}
  # tables['xxx']['data'] = Database(app.config).get_xxx_by_subject(subject)
  # tables['xxx']['header'] = friendly_names(tables['xxx']['data'])
  # * and add the data set to the parameters of render_template(...)

  return render_template('map.html', title='Samples', subject=subject, tables=tables)

def friendly_names(data_dict):
  """ Purpose:  Translate internal database column names into more user-friendly equivalents
      Workings: The translation table is intended to function as a first pass for variable names
                whose user-friendly name is not amenable to an generalized algorithmic transformation.
                For those whose database column names are the same as their user friendly names but
                for an underscore, which is many, the substitution is done in the else clause of the
                list comprehension.
  """
  if not data_dict:
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
  
  return [ translation_table[key] if key in translation_table else key.replace('_',' ') for key in data_dict[0] ]

"""
Pie chart showing data size of different assays on HuBMAP data
Validation tool (researchers upload data, validation script runs and spits out problems)
"""
