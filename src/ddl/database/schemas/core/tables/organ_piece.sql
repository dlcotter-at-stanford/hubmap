drop table if exists core.organ_piece
;
create table core.organ_piece
  (organ_piece_pk serial primary key
  ,organ_pk       integer not null references core.organ(organ_pk)
  ,organ_piece_id varchar(100) not null unique)
;
