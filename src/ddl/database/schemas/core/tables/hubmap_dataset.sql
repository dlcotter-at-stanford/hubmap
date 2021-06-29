drop table if exists core.hubmap_dataset
;
create table core.hubmap_dataset
  (hubmap_dataset_pk     serial primary key
  ,name            varchar(100)
  ,assay           varchar(100)
  ,uuid            varchar(100)
  ,globus_endpoint varchar(100)
  ,globus_path     varchar(100)
  ,submission_data varchar(100)
  ,release_data    varchar(100)
  ,status          varchar(100))
;
