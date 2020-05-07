--> connect to hubmap database
drop schema if exists reporting cascade
;
create schema reporting
;
-- By convention the primary key for each entity table will be suffixed with "_pk" and
-- the business key will be suffixed with "_id". The data type for primary keys will
-- be integer (for efficiency) and for business keys will be character (to match
-- alphanumeric naming convention of study).
drop table if exists reporting.subject cascade
;
create table reporting.subject
  (subject_pk     serial primary key
  ,subject_bk     varchar(100)
  ,disease_status varchar(100))
;
drop table if exists reporting.sample cascade
;
create table reporting.sample
  (sample_pk      serial primary key
  ,subject_pk     integer references reporting.subject(subject_pk)
  ,sample_bk      varchar(100)
  ,amount         decimal(10,2)
  ,unit           varchar(100)
  ,collection     varchar(100)
  ,organ          varchar(100)
  ,organ_piece    varchar(100)
  ,stage          varchar(100)
  ,phenotype      varchar(100)
  ,size_length    numeric(4,1)
  ,size_width     numeric(4,1)
  ,size_depth     numeric(4,1)
  ,x_coord        integer
  ,y_coord        integer
  ,dysplasia_cat  varchar(100)
  ,dysplasia_pct  integer
  ,notes          varchar(100)
  ,vap_names      varchar(100))
;
drop table if exists reporting.tissue cascade
;
create table reporting.tissue
  (tissue_pk      serial primary key
  ,sample_pk      integer references reporting.sample(sample_pk)
  ,tissue_bk      varchar(100)
  ,init_pres_mthd varchar(100)
  ,curr_pres_mthd varchar(100))
;

drop table if exists reporting."storage"
;
create table reporting."storage"
  (storage_pk serial primary key
  ,tissue_pk  integer references reporting.tissue(tissue_pk)
  ,building   varchar(100)
  ,freezer    varchar(100)
  ,rack       varchar(100)
  ,box_name   varchar(100))
;
drop table if exists reporting.assay 
;
create table reporting.assay
  (assay_pk   serial primary key
  ,tissue_pk  integer references reporting.tissue(tissue_pk)
  ,assay_type varchar(100)
  ,perf_date  date
  ,researcher varchar(100)
  ,equipment  varchar(100)
  ,seq_depth  varchar(100))
;
