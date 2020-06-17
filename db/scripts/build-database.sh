#!/bin/zsh

# Run untracked config script to set environment variables, download data, scrub PHI, etc.
source config.sh

# Fetch frequently changing data from live sources
if [ $DOWNLOAD_SAMPLE_TRACKER -eq 1 ]; then
  curl $SAMPLE_TRACKER_URL > $DATA_DIR/sample-tracker.tsv
else
  echo "Using cached copy of sample tracker"
fi

# Scrub PHI
# zsh doesn't do word splitting, hence the slightly unorthodox use of eval below
eval NAMES="($PHI)"
for NAME in $NAMES; do
  # Delete all lines containing patient names (I couldn't figure out a single-
  # line regex that would work with sed, but I'm sure it's possible).
  # -i means "make changes in place," empty-string arg means don't create a backup
  sed -i "" -e "/$NAME/d" $DATA_DIR/sample-tracker.tsv;
done

# Build database one object at a time, then load the data. Each SQL file is
# named after the type of object (database, schema, etc.) except for tables and
# functions, which are named after their name in the database. Note that you
# may need to kill all connections from the command line for this to work, in
# which case: https://stackoverflow.com/questions/5108876/kill-a-postgresql-session-connection

# Database itself
psql -q -h localhost -d postgres -U postgres -f $BASE_DIR/sql/database/database.sql

# Staging tables. Order of creation not important.
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/staging/schema.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/staging/tables/metadata_atacseq_bulk_hiseq.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/staging/tables/metadata_atacseq_single_nucleus.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/staging/tables/metadata_lipidomics.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/staging/tables/metadata_metabolomics.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/staging/tables/metadata_proteomics.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/staging/tables/metadata_rnaseq_bulk.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/staging/tables/metadata_rnaseq_single_nucleus.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/staging/tables/metadata_whole_genome_seq.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/staging/tables/pathology.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/staging/tables/sample_coordinates.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/staging/tables/sample_tracker_stg.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/staging/tables/_load_tables.sql -v data_dir="$DATA_DIR"

# Core tables and functions. Note that the order of creation is important due to
# foreign key references.
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/core/schema.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/core/tables/subject.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/core/tables/sample.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/core/tables/pathology.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/core/tables/tissue.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/core/tables/assay.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/core/tables/storage.sql
#psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/core/functions/get_tissues_and_assays_by_subject.sql
#psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/core/functions/get_atacseq_bulk_metadata.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/core/functions/get_samples.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/core/functions/get_subjects.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/core/functions/get_pathology.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/core/tables/_load_tables.sql -v data_dir="$DATA_DIR"

# Metadata tables
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/metadata/schema.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/metadata/tables/atacseq_bulk_hiseq.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/metadata/tables/atacseq_single_nucleus.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/metadata/tables/lipidomics.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/metadata/tables/metabolomics.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/metadata/tables/proteomics.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/metadata/tables/rnaseq_bulk.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/metadata/tables/rnaseq_single_nucleus.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/metadata/tables/whole_genome_seq.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/metadata/tables/_load_tables.sql -v data_dir="$DATA_DIR"

# Metadata functions
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/metadata/functions/get_rnaseq_bulk_metadata.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/metadata/functions/get_whole_genome_seq_metadata.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/metadata/functions/get_proteomics_metadata.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/metadata/functions/get_lipidomics_metadata.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/metadata/functions/get_atacseq_bulk_hiseq_metadata.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/metadata/functions/get_metabolomics_metadata.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/metadata/functions/get_rnaseq_single_nucleus_metadata.sql
psql -q -h localhost -d hubmap   -U postgres -f $BASE_DIR/sql/database/schemas/metadata/functions/get_atacseq_single_nucleus_metadata.sql
