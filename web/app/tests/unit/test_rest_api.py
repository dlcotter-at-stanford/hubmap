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
  rv = client.get('/studies')
  assert rv.data == b'[{"study_bk":"HuBMAP"}]\n'
  
def test_studies_returns_json(client):
  rv = client.get('/studies')
  assert rv.status_code == 200 and rv.is_json
