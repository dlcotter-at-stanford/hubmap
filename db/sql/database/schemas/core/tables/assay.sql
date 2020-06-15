create table core.assay
  (assay_pk   serial primary key
  ,tissue_pk  integer references core.tissue(tissue_pk)
  ,assay_type varchar(100)
  ,perf_date  date
  ,researcher varchar(100)
  ,equipment  varchar(100)
  ,seq_depth  varchar(100))
;
