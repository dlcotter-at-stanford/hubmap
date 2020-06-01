drop role if exists hubmap_user
;
create role hubmap_user with password 'hubmap_user'
;
grant usage on schema reporting to hubmap_user
;
grant select on table reporting.assay to hubmap_user
;
grant select on table reporting.pathology to hubmap_user
;
grant select on table reporting.sample to hubmap_user
;
grant select on table reporting."storage" to hubmap_user
;
grant select on table reporting.subject to hubmap_user
;

