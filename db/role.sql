drop role if exists hubmap
;
create role hubmap with password 'hubmap' with login
;
grant usage on schema reporting to hubmap
;
grant select on table reporting.assay to hubmap
;
grant select on table reporting.pathology to hubmap
;
grant select on table reporting.sample to hubmap
;
grant select on table reporting."storage" to hubmap
;
grant select on table reporting.subject to hubmap
;

