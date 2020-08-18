from loguru import logger
from psycopg2.extras import DictCursor
import decimal
import functools
import pdb
import psycopg2
import sys
import traceback

class Database:
  """PostgreSQL Database class."""

  def __init__(self, config = None):
    # This code provides some local, not-very-secure database defaults for testing.
    # Obviously, do not use these user IDs & passwords for production databases.
    if config is None or ('TESTING' in config and config['TESTING']):
      self.host     = 'localhost'
      self.port     =  5432
      self.dbname   = 'biolab'
      self.username = 'reader'
      self.password = 'reader'
    else:
      self.host     = config['DATABASE_HOST']
      self.port     = config['DATABASE_PORT']
      self.dbname   = config['DATABASE_NAME']
      self.username = config['DATABASE_USERNAME']
      self.password = config['DATABASE_PASSWORD']
    self.conn     = None

  def connect(self):
    """ Connect to a Postgres database """
    if self.conn is None or self.conn.status != 1:
      try:
        self.conn = psycopg2.connect(host=self.host, user=self.username, password=self.password, port=self.port, dbname=self.dbname)
      except psycopg2.DatabaseError as e:
        logger.error(e)
        sys.exit()

  def call_proc(self, proc, args):
    """ Run a stored procedure """
    self.connect()
    with self.conn.cursor(cursor_factory=DictCursor) as cursor:
      try:
        cursor.callproc(proc, args)
      except psycopg2.Error as e:
        logger.error(e)
        if (self.conn):
          self.conn.close()
        return

      header = [ desc[0] for desc in cursor.description ]
      data = [ row for row in cursor.fetchall() ]
      return header, data

  ### Wrappers ###
  def get_data(self, proc, args, result_prefs):
    """ Wraps call_proc() and does some post-processing """
    header, data = self.call_proc(proc, args)

    if result_prefs['stringify']:
      data = [ [ str(cell) if type(cell) in [ decimal.Decimal ] else cell for cell in row ] for row in data ]

    if result_prefs['friendly_names']:
      header = [ self.friendly_names[col] if col in self.friendly_names else col.replace('_',' ') for col in header ]

    if result_prefs['to_dataset']:
      # Return results of stored procedure as two lists: one of column names
      # and another of data values. This change came about as a response to a
      # need to order the columns in the presentation layer.
      return { 'header': header, 'data': data }
    else:  
      # Return results as list of key-value maps (suitable for JSON rendering)
      return [ { key: value for key, value in zip(header, row) } for row in data ]

  ### Helper methods ###
  def get_results_by_column_name(self, dataset, column_name):
    # Find the ordinal position of the requested column
    column_num = next(index for index, item in enumerate(dataset['header']) if item.lower() == column_name)

    # Return just the results from that column
    return [ row[column_num] for row in dataset['data'] ]

  ### Stored procedure wrappers - all return options available
  """ Prototype of basic get_XXX method
      def get_XXX(self,

                 # query arguments, e.g. criteria for SQL query
                 args = { },

                 # shape and format of returned results
                 result_prefs = { }):

        # translate from user-friendly names to those used by the stored proc
        query_args = args

        # merge passed-in result preferences with defaults
        result_prefs = {**self.result_prefs, **result_prefs}

        return self.get_data('core.get_XXX', query_args, result_prefs)
  """

  def get_studies(self, query_args = { }, result_prefs = { }):
    if type(query_args) is not dict:
      raise ValueError("Named argument 'query_args' must be dictionary. Expecting dictionary with query arguments, e.g. { 'subject': 'A001' }.")

    return self.get_data('core.get_studies', query_args, {**self.result_prefs, **result_prefs})

  def get_subjects(self, query_args = { }, result_prefs = { }):
    if type(query_args) is not dict:
      raise ValueError("Named argument 'query_args' must be dictionary. Expecting dictionary with query arguments, e.g. { 'subject': 'A001' }.")

    if 'study' not in query_args:
      raise ValueError("Missing required parameter 'study' from 'query_args' dictionary")

    # copy the passed-in dict so the original doesn't get modified when we
    # translate user-friendly names to database parameter names (messes up
    # loops like the one in get_all_metadata() )
    _args = query_args.copy()
    _args['p_study_bk'] = _args.pop('study')

    return self.get_data('core.get_subjects', _args, {**self.result_prefs, **result_prefs})

  def get_samples(self, query_args = { }, result_prefs = { }):
    if type(query_args) is not dict:
      raise ValueError("Named argument 'query_args' must be dictionary. Expecting dictionary with query arguments, e.g. { 'subject': 'A001' }.")

    if 'subject' not in query_args:
      raise ValueError("Missing required parameter 'subject' from 'query_args' dictionary")

    # copy the passed-in dict so the original doesn't get modified when we
    # translate user-friendly names to database parameter names (messes up
    # loops like the one in get_all_metadata() )
    _args = query_args.copy()
    _args['p_subject_bk'] = _args.pop('subject')

    return self.get_data('core.get_samples', _args, {**self.result_prefs, **result_prefs})

  def get_pathology_reports(self, query_args = { }, result_prefs = { }):
    if type(query_args) is not dict:
      raise ValueError("Named argument 'query_args' must be dictionary. Expecting dictionary with query arguments, e.g. { 'subject': 'A001', 'sample': 'A001-C-001' }.")

    if 'subject' not in query_args:
      raise ValueError("Missing required parameter 'subject' from 'query_args' dictionary")
      
    # copy the passed-in dict so the original doesn't get modified when we
    # translate user-friendly names to database parameter names (messes up
    # loops like the one in get_all_metadata() )
    _args = query_args.copy()
    _args['p_subject_bk'] = _args.pop('subject')

    return self.get_data('core.get_pathology', _args, {**self.result_prefs, **result_prefs})

  def get_metadata(self, assay, query_args = { }, result_prefs = { }):
    if type(assay) is not str or assay not in self.assays:
      raise ValueError("The first argument must be one of the following assays: " + str(self.assays))

    if type(query_args) is not dict:
      raise ValueError("Named argument 'query_args' must be dictionary. Expecting dictionary with query arguments, e.g. { 'subject': 'A001', 'sample': 'A001-C-001' }.")

    # copy the passed-in dict so the original doesn't get modified when we
    # translate user-friendly names to database parameter names (messes up
    # loops like the one in get_all_metadata() )
    _args = query_args.copy()
    if 'subject' in _args:
      _args['p_subject_bk'] = _args.pop('subject')
    if 'sample' in _args:
      _args['p_sample_bk'] = _args.pop('sample')

    return self.get_data('metadata.get_' + assay + '_metadata', _args, {**self.result_prefs, **result_prefs})

  def get_all_metadata(self, query_args = { }, result_prefs = { }):
    return { assay: self.get_metadata( assay, query_args, {**self.result_prefs, **result_prefs} ) for assay in self.assays }

  ### Hardcoded bits ###
  assays = \
    [ 'atacseq_bulk_hiseq'
    , 'atacseq_single_nucleus'
    , 'lipidomics'
    , 'metabolomics'
    , 'proteomics'
    , 'rnaseq_bulk'
    , 'rnaseq_single_nucleus'
    , 'whole_genome_seq' ]

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

  result_prefs = \
    { 'stringify'     : False
		 ,'friendly_names': False
		 ,'to_dataset'    : False }
