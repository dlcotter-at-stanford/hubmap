create or replace
function core.get_samples
  (p_subject_bk varchar(100)
  ,has_coordinates boolean default false)
returns table
  (sample_bk    varchar(100)
  ,size_length  numeric(4,1)
  ,size_width   numeric(4,1)
  ,size_depth   numeric(4,1)
  ,x_coord      numeric(4,1)
  ,y_coord      numeric(4,1)
  ,stage        varchar(100)
  ,phenotype    varchar(100)
  ,organ_piece  varchar(100)
  ,atacseq_bulk boolean
  ,atacseq_sn   boolean
  ,lipidomics   boolean
  ,metabolomics boolean
  ,proteomics   boolean
  ,rnaseq_bulk  boolean
  ,rnaseq_sn    boolean
  ,wgs          boolean)
language sql
as
$$
select sample_bk
  ,size_length
  ,size_width
  ,size_depth
  ,x_coord
  ,y_coord
  ,stage
  ,phenotype
  ,organ_piece
  ,atacseq_bulk
  ,atacseq_sn
  ,lipidomics
  ,metabolomics
  ,proteomics
  ,rnaseq_bulk
  ,rnaseq_sn
  ,wgs
from core.sample
join core.subject on subject.subject_pk = sample.subject_pk
where subject.subject_bk = p_subject_bk
and
   --get all records without regard to presence of coordinates
  (has_coordinates is null

   --only get records with coordinates
   or (has_coordinates is true
     and sample.x_coord is not null
     and sample.y_coord is not null)

   --only get records without coordinates
   or (has_coordinates is false
     and sample.x_coord is null
     and sample.y_coord is null))

order by sample.sample_bk
$$
