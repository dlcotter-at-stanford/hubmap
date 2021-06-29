drop table if exists core.sample
;
create table core.sample
  (sample_pk             serial primary key
  ,ancestor_pk           integer not null references core.sample(sample_pk)
  ,organ_piece_pk        integer not null references core.organ_piece(organ_piece_pk)
  ,sample_id             varchar(100) not null unique
  ,stage                 varchar(100)
  ,phenotype             varchar(100)
  ,size_length           numeric(4,1)
  ,size_width            numeric(4,1)
  ,size_depth            numeric(4,1)
  ,amount                decimal(10,2)
  ,unit                  varchar(100)
  ,notes                 varchar(200))
;
