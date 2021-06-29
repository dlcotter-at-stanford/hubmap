#! python
import google.auth
import database as db

credentials, project_id = google.auth.default(scopes=['https://www.googleapis.com/auth/cloud-platform'])
db.init("gbsc-gcp-project-hubmap", credentials)
df = db.select('subject')
print(df)
