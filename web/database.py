from loguru import logger
from psycopg2.extras import DictCursor
from typing import Dict, List, Optional
import decimal
import pdb
import psycopg2

class Database:
  """PostgreSQL Database class."""

  # defaults
  result_prefs = { 'stringify': False, 'to_dataset': False }

  def __init__(self, config = None):
    # This code provides some local, not-very-secure database defaults for testing.
    # Obviously, do not use these user IDs & passwords for production databases.
    if config is None or ('TESTING' in config and config['TESTING']):
      self.host     = 'localhost'
      self.port     =  5432
      self.dbname   = 'biolab'
      self.username = 'editor'
      self.password = 'editor'
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

  def call_proc(self, proc, args={ }, result_prefs={ }):
    """ Run a stored procedure and return results """
    self.connect()
    with self.conn.cursor(cursor_factory=DictCursor) as cursor:
      try:
        cursor.callproc(proc, args)
      except psycopg2.Error as e:
        logger.error(e)
        if (self.conn):
          self.conn.close()
        return

      # build header and data rows
      header = [ desc[0] for desc in cursor.description ]
      data = [ row for row in cursor.fetchall() ]

      # merge default result prefs with user-specified and copy into new var
      # and delete the parameter so there's no confusion
      _result_prefs = { **self.result_prefs, **result_prefs }
      del(result_prefs)

      # convert non-string columns to string
      if _result_prefs['stringify']:
        data = [ [ str(cell) if type(cell) in [ decimal.Decimal ] else cell for cell in row ] for row in data ]

      # return data as dataset (i.e. list of column names and list of data rows)
      # note: this change came about as a response to a need to order the
      # columns in the presentation layer.
      if _result_prefs['to_dataset']:
        return { 'header': header, 'data': data }

      # return results as list of key-value maps (suitable for JSON rendering)
      return [ { key: value for key, value in zip(header, row) } for row in data ]

  def do(self, operation, entity, query_args:Optional[Dict]={ }, result_prefs:Optional[Dict]={ }):
    # check that operation is one of 'get', 'put', or 'del'
    if operation not in ['get', 'put', 'del']:
      raise ValueError("Operation must be one of 'get', 'put', or 'del'")

    # check that entity is one of the ones in the database
    core = [ 'study', 'studies', 'subject', 'subjects', 'sample', 'samples', 'pathology' ]
    metadata = [ 'atacseq_bulk_hiseq', 'atacseq_single_nucleus', 'lipidomics', 'metabolomics',
                 'proteomics', 'rnaseq_bulk', 'rnaseq_single_nucleus', 'whole_genome_seq' ]

    if entity in core:
      schema = 'core'
    elif entity in metadata:
      schema = 'metadata'
    else:
      raise ValueError("Parameter 'entity' must be one of these values: " + str(core + metadata))
    proc = schema + '.' + operation + '_' + entity

    return self.call_proc(proc, query_args, result_prefs)
