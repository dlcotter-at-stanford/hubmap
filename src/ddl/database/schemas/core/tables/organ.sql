drop table if exists core.organ
;
create table core.organ
  (organ_pk     serial primary key
  ,donor_pk     integer not null references core.donor(donor_pk)
  ,organ_id     varchar(100) not null unique
  ,organ        varchar(100) not null unique)
;
