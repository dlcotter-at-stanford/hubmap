-- By convention the primary key for each entity table will be suffixed with "_pk" and
-- the business key will be suffixed with "_id". The data type for primary keys will
-- be integer (for efficiency) and for business keys will be character (to match
-- alphanumeric naming convention of study).
drop table if exists core.donor
;
create table core.donor
  (donor_pk            serial primary key
  ,study_pk            integer not null references core.study(study_pk)
  ,donor_id            varchar(100) not null unique
  ,age                 integer
  ,sex                 char
  ,race                char
  ,is_deceased         boolean
  ,is_organ_donor      boolean
  ,consent_type        varchar(100)
  ,collection_method   varchar(100)
  ,primary_dx          varchar(100)
  ,secondary_dx        varchar(100)
  ,age_at_dx           integer)
;
