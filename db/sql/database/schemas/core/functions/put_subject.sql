create or replace
function core.put_subject
         (p_study_bk            varchar(100)
         ,p_subject_bk          varchar(100)
         ,p_disease_status      varchar(100)
         ,p_rectum_position     numeric(5,2)
         ,p_descending_position numeric(5,2)
         ,p_transverse_position numeric(5,2)
         ,p_ascending_position  numeric(5,2)
         ,p_colon_length        numeric(5,2))
returns table 
         (subject_pk           integer       --used to demonstrated idempotence in REST API
         ,subject_bk           varchar(100)
         ,disease_status       varchar(100)
         ,rectum_position      numeric(5,2)
         ,descending_position  numeric(5,2)
         ,transverse_position  numeric(5,2)
         ,ascending_position   numeric(5,2)
         ,colon_length         numeric(5,2))
language sql
as
$$
insert into core.subject
            (study_pk
            ,subject_bk
            ,disease_status
            ,rectum_position
            ,descending_position
            ,transverse_position
            ,ascending_position
            ,colon_length)
select       study.study_pk
            ,p_subject_bk
            ,p_disease_status
            ,p_rectum_position
            ,p_descending_position
            ,p_transverse_position
            ,p_ascending_position
            ,p_colon_length
from        core.study
where       study_bk = p_study_bk
on conflict (subject_bk) do
update set   subject_bk = p_subject_bk
            ,disease_status = p_disease_status 
            ,rectum_position = p_rectum_position 
            ,descending_position = p_descending_position 
            ,transverse_position = p_transverse_position 
            ,ascending_position = p_ascending_position 
            ,colon_length = p_colon_length 
returning    subject_pk
            ,subject_bk
            ,disease_status
            ,rectum_position
            ,descending_position
            ,transverse_position
            ,ascending_position 
            ,colon_length
$$
