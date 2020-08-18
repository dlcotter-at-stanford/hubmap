import os
import pytest
import pdb
from app import app

@pytest.fixture
def client():
  app.config['TESTING'] = True

  with app.test_client() as client:
    with app.app_context():
      pass
  yield client

def test_studies(client):
  rv = client.get('/api/studies')
  assert rv.data == b'[{"study_bk":"HuBMAP"}]\n'
  
def test_studies_returns_json(client):
  rv = client.get('/api/studies')
  assert rv.status_code == 200 and rv.is_json

def test_studies_searches_case_insensitive(client):
  rv       = client.get('/api/studies/HuBMAP/')
  rv_lower = client.get('/api/studies/hubmap/')
  assert rv.data == rv_lower.data
