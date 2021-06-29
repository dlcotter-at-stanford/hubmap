drop table if exists core."file"
;
create table core."file"
  (file_pk     serial primary key
  ,assay_pk    integer not null references core.assay(assay_pk)
  ,file_server varchar(100)
  ,file_path   varchar(100)
  ,md5_hash    varchar(100))
;
