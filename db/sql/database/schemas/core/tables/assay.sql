create table core.assay
  (assay_pk        serial primary key
  ,tissue_pk       integer references core.tissue(tissue_pk)
  ,assay_type      varchar(100)
  ,experiment_date date
  ,researcher      varchar(100))
;
