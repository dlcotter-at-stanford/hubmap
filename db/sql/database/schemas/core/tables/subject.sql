-- By convention the primary key for each entity table will be suffixed with "_pk" and
-- the business key will be suffixed with "_id". The data type for primary keys will
-- be integer (for efficiency) and for business keys will be character (to match
-- alphanumeric naming convention of study).
create table core.subject
  (subject_pk          serial primary key
  ,study_pk            integer not null references core.study(study_pk)
  ,subject_bk          varchar(100) not null unique
  ,disease_status      varchar(100)
  ,rectum_position     decimal(5,2)
  ,descending_position decimal(5,2)
  ,transverse_position decimal(5,2)
  ,ascending_position  decimal(5,2)
  ,colon_length        decimal(5,2))
;
