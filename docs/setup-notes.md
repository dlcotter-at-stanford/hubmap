From:
https://cloud.google.com/sql/docs/postgres/sql-proxy#macos-64-bit

## How to download and install the Cloud SQL Auth proxy
curl -o cloud_sql_proxy https://dl.google.com/cloudsql/cloud_sql_proxy.darwin.amd64
chmod +x cloud_sql_proxy

## How to connect
    `psql --host=/tmp/gbsc-gcp-project-hubmap:us-west1:biolab-db --username=postgres`
    (hint: look for the password under LastPass -> biolab-db)

## How the Cloud SQL Auth proxy works
The Cloud SQL Auth proxy works by having a local client running in the local
environment. Your application communicates with the Cloud SQL Auth proxy with
the standard database protocol used by your database. The Cloud SQL Auth proxy
uses a secure tunnel to communicate with its companion process running on the
server.

