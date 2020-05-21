from app import app
from database import Database
from flask import render_template, send_from_directory

@app.route('/')
def index():
  subjects = Database().call_proc('reporting.get_subjects', { 'has_phi': False, 'has_coordinates': True })

  return render_template('index.html', title='Colon map visualization', subjects=subjects)

@app.route('/map/<subject>')
def map(subject):
  samples = Database().call_proc('reporting.get_samples', { 'p_subject_bk': subject, 'has_coordinates': True })

  return render_template('map.html', title='Samples', subject=subject, samples=samples)

