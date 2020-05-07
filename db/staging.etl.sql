--load sample tracker tab-separated flat file into staging table first
truncate table staging.sample_tracker_stg
;
copy staging.sample_tracker_stg
from '/Users/dlcott2/Documents/work/HuBMAP/dev/src/db/sample-tracker.tsv'
with delimiter E'\t' --tab separator
csv header --ignore header
;

--then add a column tissue_number with a sequentially numbered sample id (the original reuses the same sample number for each subsample)
--note: this seems cumbersome vs updating the existing table with a new row, but you can't use window functions in an update unfortunately
drop table if exists staging.sample_tracker
;
create table staging.sample_tracker as
select * 
	,sample_name || '-' || row_number() over (partition by sample_name) as tissue_number
from staging.sample_tracker_stg
;

--load sample coordinates tab-separated flat file into staging table first
truncate table staging.sample_coordinates
;
copy staging.sample_coordinates
from '/Users/dlcott2/Documents/work/HuBMAP/dev/src/db/sample-coords.tsv'
with delimiter E'\t' --tab separator
csv header --ignore header
;
