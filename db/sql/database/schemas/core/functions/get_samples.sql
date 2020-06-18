create or replace
function core.get_samples
	(p_subject_bk varchar(100)
	,has_coordinates boolean default false)
returns table
	(sample_bk   varchar(100)
	,size_length numeric(4,1)
	,size_width  numeric(4,1)
	,size_depth  numeric(4,1)
	,x_coord     int4
	,y_coord     int4
	,stage       varchar(100)
	,phenotype   varchar(100)
	,organ_piece varchar(100))
language sql
as
$$
select sample_bk, size_length, size_width, size_depth, x_coord, y_coord, stage, phenotype, organ_piece
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
$$
