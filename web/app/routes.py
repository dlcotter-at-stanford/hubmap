from app import app
from flask import render_template, send_from_directory
import psycopg2

#if __name__ == "__main__":
#  app.run(host='0.0.0.0')  # had to add the host='0.0.0.0' bit so that Flask would accept incoming connections from all IPs (see https://stackoverflow.com/a/41430229/12922300)

@app.route('/')
def index():
  subjects = []
  
  try:
    conn = psycopg2.connect(user='hubmap',password='hubmap',host='127.0.0.1',port='5432',database='hubmap')
    cursor = conn.cursor()
    cursor.execute( """select distinct subject_bk
                       from reporting.subject
                       join reporting.sample on sample.subject_pk = subject.subject_pk
                       where subject_bk ~ '^[A|B].*'
                       and sample.x_coord is not null
                       and sample.y_coord is not null
                       order by subject_bk""")
    subjects = [ { 'id': row[0] } for row in cursor.fetchall() ]
  except (Exception, psycopg2.Error) as error:
    print(error)
  finally:
    if (conn):
      cursor.close()
      conn.close()

  return render_template('index.html', title='Colon map visualization', subjects=subjects)

@app.route('/map/<subject>')
def map(subject):
  samples = []

  try:
    conn = psycopg2.connect(user='hubmap',password='hubmap',host='127.0.0.1',port='5432',database='hubmap')
    cursor = conn.cursor()
    cursor.execute("""select sample_bk, size_length, size_width, size_depth, x_coord, y_coord, stage, phenotype, organ_piece
                      from reporting.sample
                      join reporting.subject on subject.subject_pk = sample.subject_pk
                      where subject.subject_bk = '""" + subject + "' and x_coord is not null and y_coord is not null")
    samples = [ { 'sample_name': row[0]
                , 'size_length': row[1]
                , 'size_width' : row[2]
                , 'size_depth' : row[3]
                , 'x_coord'    : row[4] if row[4] else ''
                , 'y_coord'    : row[5] if row[5] else ''
                , 'stage'      : row[6]
                , 'phenotype'  : row[7]
                , 'organ_piece': row[8] }
              for row in cursor.fetchall() ]

  except (Exception, psycopg2.Error) as error:
    print(error)
  finally:
    if (conn):
      cursor.close()
      conn.close()

  return render_template('map.html', title='Samples', subject=subject, samples=samples)

