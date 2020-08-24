create or replace
function core.insert_study
         (p_study_bk varchar(100))
returns table 
         (study_pk integer       --used to demonstrated idempotence in REST API
         ,study_bk varchar(100))
language sql
as
$$
insert into core.study
            (study_bk)
values      (p_study_bk)
on conflict (study_bk) do
update set   study_bk = p_study_bk
returning    study_pk
            ,study_bk
$$

