drop table if exists core."storage"
;
create table core."storage"
  (storage_pk serial primary key
  ,building   varchar(100) not null
  ,freezer    varchar(100)
  ,rack       varchar(100)
  ,box_name   varchar(100))
;
