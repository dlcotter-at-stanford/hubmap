import sys
from loguru import logger
import psycopg2
from psycopg2.extras import DictCursor

class Database:
  """PostgreSQL Database class."""

  #def __init__(self, config):
  def __init__(self):
    self.host     = '127.0.0.1'  # config.DATABASE_HOST
    self.username = 'hubmap'     # config.DATABASE_USERNAME
    self.password = 'hubmap'     # config.DATABASE_PASSWORD
    self.port     = '5432'       # config.DATABASE_PORT
    self.dbname   = 'hubmap'     # config.DATABASE_NAME
    self.conn     = None

  def connect(self):
    """Connect to a Postgres database."""
    if self.conn is None or self.conn.status != 1:
      try:
        self.conn = psycopg2.connect(host=self.host, user=self.username, password=self.password, port=self.port, dbname=self.dbname)
      except psycopg2.DatabaseError as e:
        logger.error(e)
        sys.exit()
      finally:
        logger.info('Connection opened successfully.')

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

      col_names = [ desc[0] for desc in cursor.description ]
      results = [ dict(zip(col_names, row)) for row in cursor.fetchall() ]
      return results
