client, bucket = None, None

def init(project_id, credentials):
    from google.cloud import bigquery
    global client; client = bigquery.Client(credentials=credentials, project=project_id)

def select(table):
    query = f'select * from `core.{table}`'
    df = client.query(query).result().to_dataframe()
    return df

def write_to_bigquery(df,env):
    """Write cleansed, imputed, and normalized data back to BigQuery"""
    import pandas as pd

    assert( df.index.names == ['instrument','batch','sample','type','name'] )

    # Round to four decimal points since the values are off by fractional
    # amounts (i.e. 0.5399 mysteriously becomes 0.5398999999999999999)
    df = df.round(4)

    # Create a data frame from the single-column Series returned by the last step
    df = pd.DataFrame(data=df, columns=['value'], dtype=str) # has to be *str* for to_gbq() to work

    # Drop sample/type/name levels and get instrument and batch numbers from what remains
    run_indices = df.index.droplevel(['sample','name']).unique().values

    # Drop any samples with the same instrument and batch number as this file
    query = f"""delete from `{env}.lipidomics` where {' or '.join([ f"(batch='{batch}' and instrument='{instrument}' and type='{type}')" for (instrument, batch, type) in run_indices ])}"""
    client.query(query).result()

    # Move the indices to columns so the dataframe matches the database table
    df = df.reset_index()

    # Write dataframe to BigQuery
    schema = [ { 'name': 'instrument'    , 'type': 'STRING'  }
             , { 'name': 'batch'         , 'type': 'STRING'  }
             , { 'name': 'sample'        , 'type': 'STRING'  }
             , { 'name': 'type'          , 'type': 'STRING'  }
             , { 'name': 'name'          , 'type': 'STRING'  }
             , { 'name': 'value'         , 'type': 'NUMERIC' } ]
    df.to_gbq(f"{env}.lipidomics", if_exists='append', table_schema=schema)

def fetch_full_dataset(env):
    import pandas as pd
    query = f'select * from `{env}.lipidomics`'
    df = client.query(query).result().to_dataframe()
    df = df.set_index(['instrument','batch','sample','type','name'])
    return df.apply(pd.to_numeric)
