create table core."storage"
  (storage_pk serial primary key
  ,tissue_pk  integer references core.tissue(tissue_pk)
  ,building   varchar(100)
  ,freezer    varchar(100)
  ,rack       varchar(100)
  ,box_name   varchar(100))
;
