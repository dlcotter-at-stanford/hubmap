create or replace
function core.get_studies()
returns table
    (study_bk varchar(100))
language sql
as
$$
select distinct study_bk
from core.study
order by study_bk
$$
