# Setup

- Limited access to my home IP (67.168.69.137) and my IP connecting through Stanford's VPN (171.66.17.124)
- Decided to forego requiring SSL connection (setup got too complicated for a small project w/no PHI)
    - Had to generate client certificates from the Cloud SQL console.
        - Worked with the CLI client but not DBeaver
        - DBeaver had problems with the PEM-formatted key, so I tried
          converting it to DER but this didn't work either:
            
            ```
            openssl pkcs8 -topk8 -inform PEM -outform DER -in client-key.pem -out client-key.der
            ```
            
    - More info in [Postgres docs](https://www.postgresql.org/docs/current/ssl-tcp.html)
    - The way forward (from [Connecting using the Cloud SQL connectors](https://cloud.google.com/sql/docs/postgres/connect-connectors#setup-and-usage)): 
        > The Cloud SQL Python connector is a library that can be used alongside
        > a database driver to allow users with sufficient permissions to connect
        > to a Cloud SQL database without having to manually allowlist IPs or
        > manage SSL certificates.

# Connecting
## ...with a SQL client

1. Using [Cloud SQL Proxy](https://cloud.google.com/sql/docs/postgres/connect-admin-proxy?_ga=2.85815705.-1276919307.1623707135) and a CLI Postgres client:
	1. Run the cloud proxy process:

        ```
        ~/Documents/projects/biolab-datamart/v2/cloud_sql_proxy -dir /tmp
        ```

	2. Run the psql client:

        ```
        psql --host=/tmp/gbsc-gcp-project-hubmap:us-west1:biolab-db --username=postgres
        ```
        
    3. Run the psql client w/SSL:

        ```
        $ chmod 600 client-key.pem
        $ psql "sslmode=verify-ca sslrootcert=server-ca.pem \
          sslcert=client-cert.pem sslkey=client-key.pem \
          hostaddr=34.82.170.58 \
          user=postgres dbname=biolab"
        ```
        
2. Using dBeaver:
	1. Make sure you are connected to Stanford's network over VPN. I set
	   the instance up to only accept connections from Stanford's IP range
	   _(actually, only my IP right now - need to find out what the general
	   ranges are)_
	2. Point your client to 34.82.170.58 (or whatever the current IP is)
3. Using dBeaver, Cloud SQL Proxy, and a cumbersome workaround:
	1. Set up a GCP compute instance accepting SSH connections and forwarding them to the Cloud SQL instance
	2. Run a local SSH process connected to the compute instance
	3. Connect to the local process over SSH from dBeaver
	4. Note: This is all because dBeaver can't connect to a Unix socket

## ...programmatically
### R
```
    install.packages('RPostgres')
    library(DBI)
    con <- dbConnect(
        RPostgres::Postgres(),
        dbname='biolab',
        host='34.82.170.58',
        port=5432,
        user='postgres',
        password='shhh')
    dbListObjects(con) 
    dbSendQuery(con, "select * from core.assay")
    dbDisconnect(con)
    help(package='DBI')
```
see also: [Google Cloud Platform for Data Scientists: Using R with Google Cloud SQL for MySQL](https://cloud.google.com/blog/products/gcp/google-cloud-platform-for-data-scientists-using-r-with-google-cloud-sql-for-mysql)

### Python

Had to activate Google Auth Library:

```
    $ gcloud auth application-default login
    $ python -m pip install git+https://github.com/GoogleCloudPlatform/cloud-sql-python-connector
    $ python
        Python 3.9.1 (default, Feb 10 2021, 15:11:42) 
        [Clang 12.0.0 (clang-1200.0.32.29)] on darwin
        >>> from google.cloud.sql.connector import connector
        >>> conn = connector.connect(
        ...     "gbsc-gcp-project-hubmap:us-west1:biolab-db"
        ...     ,"pg8000"
        ...     ,user="postgres"
        ...     ,password="shhh"
        ...     ,db="biolab")
        >>> conn
        <pg8000.dbapi.Connection object at 0x10c027ac0>
        >>> cursor = conn.cursor()
        >>> cursor.execute("SELECT * from core.donor")
        >>> result = cursor.fetchall()
        >>> for row in result:
            print(row)
        ... 
        >>>
```

* Next steps:
    * Set up IAM authentication for Aaron et al.
