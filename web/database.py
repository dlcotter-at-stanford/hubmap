import sys
from loguru import logger
import psycopg2
from psycopg2.extras import DictCursor
import traceback

class Database:
  """PostgreSQL Database class."""

  def __init__(self, config):
    self.host     = config['DATABASE_HOST']
    self.username = config['DATABASE_USERNAME']
    self.password = config['DATABASE_PASSWORD']
    self.port     = config['DATABASE_PORT']
    self.dbname   = config['DATABASE_NAME']
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
    """Run a SQL query to select rows from table and return dictionarys."""
    self.connect()
    with self.conn.cursor(cursor_factory=DictCursor) as cursor:
      try:
        cursor.callproc(proc, args)
        #cursor.execute(query)
      except psycopg2.Error as e:
        logger.error(e)
        if (self.conn):
          self.conn.close()
        return

      # return results as dictionary with column names as keys
      col_names = [ desc[0] for desc in cursor.description ]
      results = [ dict(zip(col_names, row)) for row in cursor.fetchall() ]
      return results

  def get_subjects_with_mapped_samples(self):
    return self.call_proc('reporting.get_subjects', { 'has_phi': False, 'has_coordinates': True })

  def get_samples_with_coordinates(self, subject):
    return self.call_proc('reporting.get_samples', { 'p_subject_bk': subject, 'has_coordinates': True })

  def get_pathology_by_subject(self, subject):
    results = self.call_proc('reporting.get_pathology', { 'p_subject_bk': subject })

    # Replace the underscores in the names of the attributes returned by the stored procedure with
    # spaces for user friendliness. The names have underscores in the first place because this stored
    # procedures unpivots table columns into rows of key-value pairs.
    for r in results:
      r['attr'] = r['attr'].replace('_',' ')

    return results
