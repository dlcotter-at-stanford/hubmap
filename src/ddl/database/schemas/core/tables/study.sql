-- By convention the primary key for each entity table will be suffixed with "_pk" and
-- the business key will be suffixed with "_id". The data type for primary keys will
-- be integer (for efficiency) and for business keys will be character (to match
-- alphanumeric naming convention of study).
drop table if exists core.study
;
create table core.study
  (study_pk     serial primary key
  ,study_id     varchar(100) not null unique)
;
