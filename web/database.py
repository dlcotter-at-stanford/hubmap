import functools
from loguru import logger
import psycopg2
from psycopg2.extras import DictCursor
import sys
import traceback

class Database:
  """PostgreSQL Database class."""

  def __init__(self, config = None):
    # This code provides some local, not-very-secure database defaults for testing.
    # Obviously, do not use these user IDs & passwords for production databases.
    if config is None:
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
    """Connect to a Postgres database."""
    if self.conn is None or self.conn.status != 1:
      try:
        self.conn = psycopg2.connect(host=self.host, user=self.username, password=self.password, port=self.port, dbname=self.dbname)
      except psycopg2.DatabaseError as e:
        logger.error(e)
        sys.exit()

  def call_proc(self, proc, args):
    """Run a SQL query to select rows from table and return dictionaries."""
    self.connect()
    with self.conn.cursor(cursor_factory=DictCursor) as cursor:
      try:
        cursor.callproc(proc, args)
      except psycopg2.Error as e:
        logger.error(e)
        if (self.conn):
          self.conn.close()
        return

      # Return results of stored procedure as two lists: one of column names
      # and another of data values. This change came about as a response to a
      # need to order the columns in the presentation layer. Initially the
      # results were being returned as a dictionary with column names as keys,
      # but dictionaries don't preserve order. I looked into using ordered
      # dictionaries, but in the end this seemed simpler.
      header = [ desc[0] for desc in cursor.description ]
      data = [ row for row in cursor.fetchall() ]

      # Translate internal database column names into more user-friendly
      # equivalents. For those whose database column names are the same as
      # their user friendly names but for an underscore, which is many, the
      # substitution is done in the else clause of the list comprehension.
      # For all others, the translation table provides the user-friendly name
      # The wrapped function will return a data set with a field 'header'.
      translation_table = { 'subject_bk' : 'subject'
                           ,'sample_bk'  : 'sample name'
                           ,'size_length': 'length'
                           ,'size_width' : 'width'
                           ,'size_depth' : 'depth'
                           ,'x_coord'    : 'x'
                           ,'y_coord'    : 'y'
                           ,'organ_piece': 'location'
                           ,'attr'       : 'attribute'}
      
      header = [ translation_table[col] if col in translation_table else col.replace('_',' ') for col in header ]

      return { 'header': header, 'data': data }

  def get_results_by_column_name(self, dataset, column_name):
    # Find the ordinal position of the requested column
    column_num = next(index for index, item in enumerate(dataset['header']) if item.lower() == column_name)

    # Return just the results from that column
    return [ row[column_num] for row in dataset['data'] ]

  ### Stored procedure wrappers
  def get_subjects_with_mapped_samples(self):
    return self.call_proc('core.get_subjects', { 'has_phi': False, 'has_coordinates': True })

  def get_samples_with_coordinates(self, subject):
    return self.call_proc('core.get_samples', { 'p_subject_bk': subject, 'has_coordinates': True })

  def get_pathology_by_subject(self, subject):
    return self.call_proc('core.get_pathology', { 'p_subject_bk': subject })
    
  def get_metadata(self, metadata_type, subject, sample=None):
    # Not sure this is the right way to raise this error, but at least
    # something will happen if the metadata type isn't supported.
    if metadata_type not in ['atacseq_bulk_hiseq', 'atacseq_single_nucleus', 'lipidomics', 'metabolomics', 'proteomics', 'rnaseq_bulk', 'rnaseq_single_nucleus', 'whole_genome_seq' ]:
      raise
    else:
      return self.call_proc('metadata.get_' + metadata_type + '_metadata', { 'p_subject_bk': subject, 'p_sample_bk': sample })

  def get_all_metadata(self, subject, sample=None):
    return { assay: self.get_metadata(assay, subject, sample) for assay in [ 'atacseq_bulk_hiseq', 'atacseq_single_nucleus', 'lipidomics', 'metabolomics', 'proteomics', 'rnaseq_bulk', 'rnaseq_single_nucleus', 'whole_genome_seq' ] }
