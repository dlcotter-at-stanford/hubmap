-- By convention the primary key for each entity table will be suffixed with "_pk" and
-- the business key will be suffixed with "_id". The data type for primary keys will
-- be integer (for efficiency) and for business keys will be character (to match
-- alphanumeric naming convention of study).
create table core.subject
  (subject_pk     serial primary key
  ,subject_bk     varchar(100)
  ,disease_status varchar(100))
;
