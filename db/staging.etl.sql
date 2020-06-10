--This script is meant to be called from the command line:
--psql -h localhost -U postgres -d hubmap -f staging.etl.sql

--load sample tracker tab-separated flat file into staging table first
truncate table staging.sample_tracker_stg
;
--set up paths for different files
--The backticks in the first "set" command let us use the output of a shell command to set the path
--variable, which helps make the script portable between dev and prod environments. The variable is
--read with the colon operator, and concatenation with the file name happens automatically.
\set pwd `pwd`
\set sample_tracker_path :pwd '/sample-tracker.tsv'
\set sample_coords_path  :pwd '/sample-coords.tsv'
\set pathology_path      :pwd '/pathology.tsv'
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
truncate table staging.sample_coordinates
;
copy staging.sample_coordinates
from :'sample_coords_path'
with delimiter E'\t' --tab separator
csv header --ignore header
;

--load pathology tab-separated flat file into staging table first
truncate table staging.pathology
;
copy staging.pathology
from :'pathology_path'
with delimiter E'\t' --tab separator
csv header --ignore header
;
-- delete example row
delete from staging.pathology where sample = 'Examples of Responses'
