from app import app
import pdb
import pytest
import requests

@pytest.fixture
def client():
  # TESTING tells Flask that the app is in test mode. Flask changes some
  # internal behavior so it’s easier to test, and other extensions can also use
  # the flag to make testing them easier.
  app.config['TESTING'] = True

  with app.test_client() as client:
    with app.app_context():
      pass
  yield client

def test_get_studies(client):
  # won't show up in running app since it's using a test client
  rv = client.get('/api/studies/')
  assert rv.status_code == 200 and rv.data
  
def test_post_study_rejects_json_without_header():
  # requires a local web server to be running (not just a mock app client)
  r = requests.post("http://127.0.0.1:5000/api/studies/"
                   # missing --> ,headers = {"Content-Type": "application/json"}
                   ,data = "{""study"": ""HTAN""}")
  assert r.status_code == 404

def test_post_study_rejects_malformed_json():
  # requires a local web server to be running (not just a mock app client)
  r = requests.post("http://127.0.0.1:5000/api/studies/"
                   ,headers = {"Content-Type": "application/json"}
                   ,data = "{'study': 'HTAN'}")  # single quotes should be double
  assert r.status_code == 404

def test_post_study():
  # requires a local web server to be running (not just a mock app client)
  req = requests.post("http://127.0.0.1:5000/api/studies/"
                     ,headers = {"Content-Type": "application/json"}
                     ,data    = '{"study": "HTAN"}')
  res = requests.get("http://127.0.0.1:5000/api/studies/HTAN/subjects/")
  assert res.status_code == 200

def test_post_subject():
  # requires a local web server to be running (not just a mock app client)
  req = requests.post("http://127.0.0.1:5000/api/studies/HTAN/subjects/"
                     ,headers = {"Content-Type": "application/json"}
                     ,data    = '{"study": "HTAN", "subject": "A001"}')
  res = requests.get("http://127.0.0.1:5000/api/studies/HTAN/subjects/")
  assert res.status_code == 200

#def test_post_study_idempotent():
#  # post the same thing twice and make sure the responses are identical
#  assert False

def test_get_studies_returns_json(client):
  # won't show up in running app since it's using a test client
  rv = client.get('/api/studies/')
  assert rv.status_code == 200 and rv.is_json

def test_get_studies_searches_case_insensitive(client):
  # won't show up in running app since it's using a test client
  rv       = client.get('/api/studies/HuBMAP/')
  rv_lower = client.get('/api/studies/hubmap/')
  assert rv.data == rv_lower.data

#def test_call_proc_with_friendly_names_returning_dataset(db):
#  results = db.call_proc('core.get_subjects'
#                      ,{ 'p_study_bk': 'HuBMAP' }
#                      ,{ 'friendly_names': True, 'to_dataset': True,})
#  assert type(results) is dict
#  assert len(results) > 0
#  assert 'header' in results
#  assert 'subject_bk' not in results['header']
#  assert 'subject' in results['header']
#
#def test_call_proc_with_friendly_names(db):
#  results = db.call_proc('core.get_subjects'
#                      ,{ 'p_study_bk': 'HuBMAP' }
#                      ,{ 'friendly_names': True })
#  assert type(results) is list
#  assert len(results) > 0
#  assert all( [ 'subject_bk' not in row.keys() for row in results ] )
#  assert all( [ 'subject' in row.keys() for row in results ] )
#
