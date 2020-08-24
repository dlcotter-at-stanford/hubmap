create table core.tissue
  (tissue_pk      serial primary key
  ,sample_pk      integer not null references core.sample(sample_pk)
  ,tissue_bk      varchar(100) unique
  ,init_pres_mthd varchar(100)
  ,curr_pres_mthd varchar(100))
;
