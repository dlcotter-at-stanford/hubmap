#!/bin/zsh

# Debugging options
set VERBOSE
set XTRACE

# Exit on error
set -e

# Check whether environment variables are set
if [ -z $DOWNLOAD_SAMPLE_TRACKER ]; then
  echo "ERROR: Environment variables not found" && exit 2
fi

# Fetch frequently changing data from live sources
if [ $DOWNLOAD_SAMPLE_TRACKER -eq 1 ]; then
  curl $SAMPLE_TRACKER_URL > db/data/sample-tracker.tsv
else
  echo "Using cached copy of sample tracker"
fi

# Delete all lines containing patient names (-E to use extended regexp)
# Note: Fluky differences between sed's behavior on my local OS X environment
# and the Debian production environment in which it runs wasted a lot of time
# debugging. The following command works in both environments, unlike the ones
# I tried with -i/--in-place and --regexp-extended.
sed -E '/^(EP|ES|JC|JP|NBM)/d' db/data/sample-tracker-raw.tsv > db/data/sample-tracker.tsv

# Build database one object at a time, then load the data. Each SQL file is
# named after the type of object (database, schema, etc.) except for tables and
# functions, which are named after their name in the database. Note that you
# may need to kill all connections from the command line for this to work, in
# which case: https://stackoverflow.com/questions/5108876/kill-a-postgresql-session-connection

DATA_DIR=$(pwd)/db/data

# Database itself
psql -q -h localhost -d postgres -U postgres -f db/sql/database/database.sql

# Staging tables. Order of creation not important.
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/staging/schema.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/staging/tables/colon_measurements.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/staging/tables/metadata_atacseq_bulk_hiseq.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/staging/tables/metadata_atacseq_single_nucleus.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/staging/tables/metadata_lipidomics.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/staging/tables/metadata_metabolomics.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/staging/tables/metadata_proteomics.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/staging/tables/metadata_rnaseq_bulk.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/staging/tables/metadata_rnaseq_single_nucleus.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/staging/tables/metadata_whole_genome_seq.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/staging/tables/pathology.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/staging/tables/sample_coordinates.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/staging/tables/sample_tracker_stg.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/staging/tables/_load_tables.sql -v data_dir="$DATA_DIR"

# Core tables and functions. Note that the order of creation is important due to
# foreign key references.
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/core/schema.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/core/tables/study.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/core/tables/subject.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/core/tables/sample.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/core/tables/pathology.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/core/tables/tissue.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/core/tables/assay.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/core/tables/storage.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/core/tables/_load_tables.sql -v data_dir="$DATA_DIR"
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/core/functions/get_samples.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/core/functions/get_subjects.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/core/functions/get_pathology.sql

# Metadata tables
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/metadata/schema.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/metadata/tables/atacseq_bulk_hiseq.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/metadata/tables/atacseq_single_nucleus.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/metadata/tables/lipidomics.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/metadata/tables/metabolomics.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/metadata/tables/proteomics.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/metadata/tables/rnaseq_bulk.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/metadata/tables/rnaseq_single_nucleus.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/metadata/tables/whole_genome_seq.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/metadata/tables/_load_tables.sql -v data_dir="$DATA_DIR"

# Metadata functions
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/metadata/functions/get_rnaseq_bulk_metadata.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/metadata/functions/get_whole_genome_seq_metadata.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/metadata/functions/get_proteomics_metadata.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/metadata/functions/get_lipidomics_metadata.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/metadata/functions/get_atacseq_bulk_hiseq_metadata.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/metadata/functions/get_metabolomics_metadata.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/metadata/functions/get_rnaseq_single_nucleus_metadata.sql
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/schemas/metadata/functions/get_atacseq_single_nucleus_metadata.sql

# Security settings
psql -q -h localhost -d biolab   -U postgres -f db/sql/database/roles/role.sql
psql -q -h localhost -d biolab   -U postgres -c "alter user reader with password '$READER_PW'"
