--This script is expecting the "data_dir" parameter to be passed in from the
--command line, i.e. db/scripts/build-database.sh

\set sample_tracker_path :data_dir '/sample-tracker.tsv'
;
--load sample tracker tab-separated flat file into staging table first
--truncate table staging.sample_tracker_stg
;
copy staging.sample_tracker_stg
from :'sample_tracker_path'
with delimiter E'\t' --tab separator
csv header --ignore header
;

--then add a column tissue_number with a sequentially numbered sample id (the original reuses the same sample number for each subsample)
--note: this seems cumbersome vs updating the existing table with a new row, but you can't use window functions in an update, unfortunately
--drop table if exists staging.sample_tracker
--;
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
--delete example row
delete from staging.pathology where sample = 'Examples of Responses'
;

--load metadata
--ATAC-seq bulk-HiSeq metadata
\set metadata_atacseq_bulk_path :data_dir '/assay-metadata/atacseq/bulk-hiseq/metadata.tsv'
;
copy staging.metadata_atacseq_bulk_hiseq
from :'metadata_atacseq_bulk_path'
with delimiter E'\t' --tab separator
csv header --ignore header
;
--ATAC-seq single-nucleus metadata
\set metadata_atacseq_single_nucleus_path :data_dir '/assay-metadata/atacseq/single-nucleus/metadata.tsv'
;
copy staging.metadata_atacseq_single_nucleus
from :'metadata_atacseq_single_nucleus_path'
with delimiter E'\t' --tab separator
csv header --ignore header
;
--Lipidomics metadata
\set metadata_lipidomics_path :data_dir '/assay-metadata/lipidomics/metadata.tsv'
;
copy staging.metadata_lipidomics
from :'metadata_lipidomics_path'
with delimiter E'\t' --tab separator
csv header --ignore header
;
--Metabolomics metadata
\set metadata_metabolomics_path :data_dir '/assay-metadata/metabolomics/metadata.tsv'
;
copy staging.metadata_metabolomics
from :'metadata_metabolomics_path'
with delimiter E'\t' --tab separator
csv header --ignore header
;
--Proteomics metadata
\set metadata_proteomics_path :data_dir '/assay-metadata/proteomics/metadata.tsv'
;
copy staging.metadata_proteomics
from :'metadata_proteomics_path'
with delimiter E'\t' --tab separator
csv header --ignore header
;
--RNA-seq bulk metadata
\set metadata_rnaseq_bulk_path :data_dir '/assay-metadata/rnaseq/bulk/metadata.tsv'
;
copy staging.metadata_rnaseq_bulk
from :'metadata_rnaseq_bulk_path'
with delimiter E'\t' --tab separator
csv header --ignore header
;
--RNA-seq single-nucleus metadata
\set metadata_rnaseq_single_nucleus_path :data_dir '/assay-metadata/rnaseq/single-nucleus/metadata.tsv'
;
copy staging.metadata_rnaseq_single_nucleus
from :'metadata_rnaseq_single_nucleus_path'
with delimiter E'\t' --tab separator
csv header --ignore header
;
--Whole-genome sequencing metadata
\set metadata_wgs_path :data_dir '/assay-metadata/wgs/metadata.tsv'
;
copy staging.metadata_whole_genome_seq
from :'metadata_wgs_path'
with delimiter E'\t' --tab separator
csv header --ignore header
;
