create or replace
function core.put_tissue
        (p_study_bk       varchar(100)
        ,p_subject_bk     varchar(100)
        ,p_sample_bk      varchar(100)
        ,p_tissue_bk      varchar(100)
        ,p_init_pres_mthd varchar(100)
        ,p_curr_pres_mthd varchar(100))
returns table
        (tissue_pk        integer       --used to demonstrated idempotence in REST API
        ,tissue_bk        varchar(100)
        ,init_pres_mthd   varchar(100)
        ,curr_pres_mthd   varchar(100))
language sql
as
$$
insert into  core.tissue
            (sample_pk
            ,tissue_bk
            ,init_pres_mthd
            ,curr_pres_mthd)
select       sample.sample_pk
            ,p_tissue_bk
            ,p_init_pres_mthd
            ,p_curr_pres_mthd
from         core.sample
join         core.subject on subject.subject_pk = sample.subject_pk
join         core.study on study.study_pk = subject.study_pk
where        sample.sample_bk = p_sample_bk
and          subject.subject_bk = p_subject_bk
and          study.study_bk = p_study_bk
on conflict (tissue_bk) do
update set   tissue_bk = p_tissue_bk
            ,init_pres_mthd = p_init_pres_mthd
            ,curr_pres_mthd = p_curr_pres_mthd
returning    tissue_pk
            ,tissue_bk
            ,init_pres_mthd
            ,curr_pres_mthd
$$

