import os
from flask import Flask

app = Flask(__name__)
app.debug = True
#  app._static_folder = os.path.abspath('templates/static/')  # not necessary but may be useful later - Flask's default static dir is ./app/static/

from app import routes
