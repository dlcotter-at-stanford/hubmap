from app import app
import database
import flask

@app.route('/')
def index():
  subjects = database.Database(app.config).get_subjects_with_mapped_samples()

  return flask.render_template('index.html', title='Colon map visualization', subjects=subjects)

@app.route('/map/<subject>')
def map(subject):
  # Determine whether the subject passed in through the URL is a valid subject.
  # Rather than hardcoding the position of the relevant column, I am searching
  # through all the columns and making a list of those with a matching name
  # (there should only be one, but you never know), then looking through those
  # columns for a subject matching the one passed in through the request. This
  # is admittedly a bit complicated, but it is robust to changes in column ordering,
  # and I will probably refactor it later into its own function in the Database
  # class, since I believe I am doing something similar in another place.
  subject_data = database.Database(app.config).get_subjects_with_mapped_samples()

  # If there are no subjects found, redirect rather than getting awkward "can't
  # subscript None" error (shouldn't happen ever really, but cropped up in test)
  if subject_data is None:
    return flask.redirect('/')

  id_column = [ index for index, item in enumerate(subject_data['header']) if item.lower() == 'subject_bk' ]
  subjects = [ row[i] for row in subject_data['data'] for i in id_column ]

  # Handle bad requests (i.e. non-existent subjects). Should probably be a 404
  # but this is easier for now (hack).
  if (subject not in subjects):
    return flask.redirect('/')

  # Get the data to be used in the web page. To add new data set, just add the
  # name and database call here and add the data set to the parameters of
  # render_template(...)
  datasets = { 'clinical'                       : database.Database(app.config).get_samples_with_coordinates(subject)
              ,'pathology'                      : database.Database(app.config).get_pathology_by_subject(subject) 
              ,'metadata.atacseq_bulk_hiseq'    : database.Database(app.config).get_metadata('atacseq_bulk_hiseq'    , subject, None) 
              ,'metadata.atacseq_single_nucleus': database.Database(app.config).get_metadata('atacseq_single_nucleus', subject, None) 
              ,'metadata.lipidomics'            : database.Database(app.config).get_metadata('lipidomics'            , subject, None) 
              ,'metadata.metabolomics'          : database.Database(app.config).get_metadata('metabolomics'          , subject, None) 
              ,'metadata.proteomics'            : database.Database(app.config).get_metadata('proteomics'            , subject, None) 
              ,'metadata.rnaseq_bulk'           : database.Database(app.config).get_metadata('rnaseq_bulk'           , subject, None) 
              ,'metadata.rnaseq_single_nucleus' : database.Database(app.config).get_metadata('rnaseq_single_nucleus' , subject, None) 
              ,'metadata.whole_genome_seq'      : database.Database(app.config).get_metadata('whole_genome_seq'      , subject, None) }

  # Prepare the data set to be passed to the template. It is possible to do this
  # in a single-line list comprehension, but it's not nearly as legible that way.
  tables = {}
  for name, dataset in datasets.items():
    if dataset['data'] == []:
      continue
    tables[name] = {}
    tables[name]['header'] = friendly_names(dataset['header'])
    tables[name]['data'] = dataset['data']

  # Get a list of other available subjects to browse from sidebar
  # Note: This data set needs to be separate from those in "datasets" or it
  # will show up in the tabbed tables along with clinical, pathology, etc.
  other_subjects = database.Database(app.config).get_subjects_with_mapped_samples()

  return flask.render_template('map.html', title='Samples', subject=subject, tables=tables, other_subjects=other_subjects)

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
