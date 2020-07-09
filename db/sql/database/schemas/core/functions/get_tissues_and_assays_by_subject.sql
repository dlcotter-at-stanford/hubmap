create or replace
function core.get_tissues_and_assays_by_subject
	(p_subject_bk varchar(100)
	,has_coordinates boolean default false)
returns table
	(tissue_bk      varchar(100)
	,init_pres_mthd varchar(100)
	,curr_pres_mthd varchar(100)
	,assay_type     varchar(100)
	,perf_date      date
	,researcher     varchar(100)
	,equipment      varchar(100)
	,seq_depth      varchar(100))
language sql
as
$$
select tissue_bk, init_pres_mthd, curr_pres_mthd, assay_type, perf_date, researcher, equipment, seq_depth
from core.subject 
join core.sample on subject.subject_pk = sample.subject_pk
join core.tissue on sample.sample_pk = tissue.sample_pk
left join core.assay on tissue.tissue_pk = assay.tissue_pk
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

order by sample.sample_bk, tissue.tissue_bk
$$
;
