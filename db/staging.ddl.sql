--> connect to hubmap database
;
drop schema if exists staging cascade
;
create schema staging
;
drop table if exists staging.sample_tracker_stg
;
create table staging.sample_tracker_stg
  (sample_name            varchar(100)
  ,patient                varchar(100)
  ,building               varchar(100)
  ,freezer                varchar(100)
  ,rack                   varchar(100)
  ,box_name               varchar(100)
  ,collection             varchar(100)
  ,amt_mg                 varchar(100)
  ,amt_ul                 varchar(100)
  ,preservation_method    varchar(100)
  ,current_state          varchar(100)
  ,donor_disease_status   varchar(100)
  ,stage                  varchar(100)
  ,phenotype              varchar(100)
  ,sample_location        varchar(100)
  ,size_mm                varchar(100)
  ,dna_wgs                varchar(100)
  ,dna_wes                varchar(100)
  ,wg_bisulfite           varchar(100)
  ,rna_seq                varchar(100)
  ,bulk_atac              varchar(100)
  ,single_gland_atac_wgs  varchar(100)
  ,sn_rna_seq             varchar(100)
  ,sn_atac_seq            varchar(100)
  ,sc_atac_seq            varchar(100)
  ,sc_rna_seq             varchar(100)
  ,he_codex               varchar(100)
  ,protein_isolation      varchar(100)
  ,rna_isolation          varchar(100)
  ,dna_isolation          varchar(100)
  ,proteomics             varchar(100)
  ,lipidomics             varchar(100)
  ,metabolomics           varchar(100)
  ,dysplasia_category     varchar(100)
  ,dysplasia_percentage   varchar(100)
  ,notes                  varchar(250)
  ,vap_names              varchar(100)
  ,batch_3_he_initial_set varchar(100)
  ,batch_3_assay          varchar(100)
  ,all_assays             varchar(100)
  ,single_nuclei          varchar(100)
)
;
drop table if exists staging.sample_coordinates
;
create table staging.sample_coordinates
  (sample_name  varchar(100)
  ,x            integer
  ,y            integer)
  