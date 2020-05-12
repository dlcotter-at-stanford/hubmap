select distinct subject_bk
from reporting.subject
join reporting.sample on sample.subject_pk = subject.subject_pk
where subject_bk ~ '^[A|B].*'
and sample.x_coord is not null
and sample.y_coord is not null
order by subject_bk