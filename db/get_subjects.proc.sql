drop function if exists get_subjects(character varying)
;
create or replace
function reporting.get_subjects
	(has_phi boolean default false
	,has_coordinates boolean default false)
returns table (subject_bk varchar(100))
language sql
as
$$
select distinct subject_bk
from reporting.subject
join reporting.sample on sample.subject_pk = subject.subject_pk
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