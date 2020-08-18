create or replace
function core.get_subjects
  (p_study_bk character varying
	,has_phi boolean default null
	,has_coordinates boolean default null)
returns table
    (subject_bk          varchar(100)
    ,disease_status      varchar(100)
    ,colon_length        numeric(5,2)
    ,rectum_position     numeric(5,2)
    ,descending_position numeric(5,2)
    ,ascending_position  numeric(5,2)
    ,transverse_position numeric(5,2))
language sql
as
$$
select distinct subject_bk, disease_status, colon_length, rectum_position, descending_position, ascending_position, transverse_position
from core.study
join core.subject on subject.study_pk = study.study_pk
join core.sample on sample.subject_pk = subject.subject_pk
where lower(study_bk) = p_study_bk
and (has_phi is null or has_phi = subject_bk !~ '^[A|B].*')
and (has_coordinates is null or has_coordinates = (sample.x_coord is not null and sample.y_coord is not null))
order by subject_bk
$$
