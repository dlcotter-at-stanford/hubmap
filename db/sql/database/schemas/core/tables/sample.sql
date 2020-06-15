create table core.sample
  (sample_pk      serial primary key
  ,subject_pk     integer references core.subject(subject_pk)
  ,sample_bk      varchar(100)
  ,amount         decimal(10,2)
  ,unit           varchar(100)
  ,collection     varchar(100)
  ,organ          varchar(100)
  ,organ_piece    varchar(100)
  ,stage          varchar(100)
  ,phenotype      varchar(100)
  ,size_length    numeric(4,1)
  ,size_width     numeric(4,1)
  ,size_depth     numeric(4,1)
  ,x_coord        integer
  ,y_coord        integer
  ,dysplasia_cat  varchar(100)
  ,dysplasia_pct  integer
  ,notes          varchar(200)
  ,vap_names      varchar(100))
;
