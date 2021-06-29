-- By convention the primary key for each entity table will be suffixed with "_pk" and
-- the business key will be suffixed with "_id". The data type for primary keys will
-- be integer (for efficiency) and for business keys will be character (to match
-- alphanumeric naming convention of study).
drop table if exists core.file_to_dataset
;
create table core.file_to_dataset
  (study_pk   integer not null
  ,file_pk    integer not null
  ,dataset_pk integer not null
  ,primary key (study_pk, file_pk, dataset_pk))
;
