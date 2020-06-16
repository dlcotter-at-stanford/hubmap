--This script is expecting the "data_dir" parameter to be passed in from the
--command line, i.e. db/scripts/build-database.sh

\set sample_tracker_path :data_dir '/sample-tracker.tsv'
;
--load sample tracker tab-separated flat file into staging table first
truncate table staging.sample_tracker_stg
;
copy staging.sample_tracker_stg
from :'sample_tracker_path'
with delimiter E'\t' --tab separator
csv header --ignore header
;

--then add a column tissue_number with a sequentially numbered sample id (the original reuses the same sample number for each subsample)
--note: this seems cumbersome vs updating the existing table with a new row, but you can't use window functions in an update, unfortunately
drop table if exists staging.sample_tracker
;
create table staging.sample_tracker as
select *, sample_name || '-' || row_number() over (partition by sample_name) as tissue_number
from staging.sample_tracker_stg
;

--load sample coordinates tab-separated flat file into staging table first
\set sample_coords_path  :data_dir '/sample-coords.tsv'
;
truncate table staging.sample_coordinates
;
copy staging.sample_coordinates
from :'sample_coords_path'
with delimiter E'\t' --tab separator
csv header --ignore header
;

--load pathology tab-separated flat file into staging table first
\set pathology_path      :data_dir '/pathology.tsv'
;
truncate table staging.pathology
;
copy staging.pathology
from :'pathology_path'
with delimiter E'\t' --tab separator
csv header --ignore header
;
-- delete example row
delete from staging.pathology where sample = 'Examples of Responses'
;

--load metadata
\set metadata_atacseq_bulk_path :data_dir '/assay-metadata/atacseq/bulk-hiseq/metadata.tsv'
;
copy staging.metadata_atacseq_bulk_hiseq
from :'metadata_atacseq_bulk_path'
with delimiter E'\t' --tab separator
csv header --ignore header
;
