create or replace
function core.get_subjects
	(has_phi boolean default false
	,has_coordinates boolean default false)
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
from core.subject
join core.sample on sample.subject_pk = subject.subject_pk
where
	 --get all records without regard to PHI
	(has_phi is null

	 --only get records with PHI
	 or (has_phi is true and subject_bk !~ '^[A|B].*')

	 --only get records without PHI
	 or (has_phi is false and subject_bk ~ '^[A|B].*'))

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

order by subject_bk
$$
