import database
import pytest

@pytest.fixture
def db():
  return database.Database()

def test_connectivity(db):
  db.connect()
  assert db.conn

def test_call_proc_without_params(db):
  results = db.call_proc('core.get_studies')

  # vanilla call to db.call_proc(proc) should return a list of dictionaries,
  # which are key-value pairs of column names and row values
  assert type(results) is list
  assert len(results) > 0
  assert all( [ type(el) is dict for el in results ] )

def test_call_proc_with_params(db):
  results = db.call_proc('core.get_subjects', { 'p_study_bk': 'HuBMAP' })
  assert type(results) is list
  assert len(results) > 0

def test_call_proc_with_stringify(db):
  results = db.call_proc('core.get_subjects', { 'p_study_bk': 'HuBMAP' }, { 'stringify': True })

  # all returned values should be string unless they're nulls
  assert type(results) is list
  assert len(results) > 0
  assert all( [ type(value) is str or value is None
                for row in results
                for value in row.values() ] )

def test_call_proc_returning_dataset(db):
  results = db.call_proc('core.get_subjects', { 'p_study_bk': 'HuBMAP' }, { 'to_dataset': True })
  assert type(results) is dict
  assert len(results) > 0
  assert 'header' in results
  assert 'data' in results

def test_call_proc_with_stringify_returning_dataset(db):
  results = db.call_proc('core.get_subjects'
                      ,{ 'p_study_bk': 'HuBMAP' }
                      ,{ 'stringify': True, 'to_dataset': True })
  assert type(results) is dict
  assert len(results) > 0
  assert all( [ type(value) is str or value is None
                for row in results['data']
                for value in row ] )

def test_do_check_operation_value_error(db):
  with pytest.raises(ValueError):
    assert db.do('insert', 'something')

def test_get_entity_check_value_error(db):
  with pytest.raises(ValueError):
    assert db.do('get', 'nonsense')

def test_get_studies(db):
  results = db.do('get', 'studies')
  assert results

def test_get_subjects(db):
  results = db.do('get', 'subjects', { 'p_study_bk': 'HuBMAP' })
  assert results

def test_get_samples(db):
  results = db.do('get', 'samples', { 'p_study_bk': 'HuBMAP', 'p_subject_bk': 'A001' })
  assert results

def test_get_pathology(db):
  results = db.do('get', 'pathology', { 'p_study_bk': 'HuBMAP', 'p_subject_bk': 'A001' })
  assert results

# Holding off on testing metadata for the moment. We have metadata for assays
# done of samples that are not in the sample tracker (B001, etc.), so there is
# no way to link them to a sample via a foreign key, and the query for them
# comes up blank. Eventually we will have the sample metadata for them, surely.

#def test_get_metadata(db):
#  results = db.do('get', 'atacseq_bulk_hiseq', { 'p_subject_bk': 'A001', 'p_sample_bk': 'A001-C-002' })
#  assert results
