#!/usr/bin/env python
import datetime, getopt, os, shutil, urllib.request

def download_source_file(source_url, saved_filename):
  urllib.request.urlretrieve(source_url, filename=saved_filename)
  print('File at ' + source_url + ' downloaded and saved as ' + saved_filename)
  
def cleanup_and_archive(input_file_path, archive_file_path):
  shutil.copyfile(input_file_path, archive_file_path)
  print('File at ' + input_file_path + ' downloaded and saved as ' + archive_file_path)

### SCRIPT VARIABLES
source_file_url = os.environ['SAMPLE_TRACKER_URL']
input_file_path = 'sample-tracker.tsv'

download_source_file(source_file_url, input_file_path)
cleanup_and_archive(input_file_path, archive_file_path):
