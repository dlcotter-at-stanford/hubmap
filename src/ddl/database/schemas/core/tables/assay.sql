drop table if exists core.assay
;
create table core.assay
  (assay_pk                      serial primary key
  ,tissue_pk                     integer not null references core.sample(sample_pk)
  ,execution_datetime            date
  ,protocols_io_doi              varchar(200)
  ,operator                      varchar(100)
  ,operator_email                varchar(100)
  ,pi                            varchar(100)
  ,pi_email                      varchar(100)
  ,assay_category                varchar(100)
  ,analyte_class                 varchar(100)
  ,is_targeted                   boolean
  ,acquisition_instrument_vendor varchar(100)
  ,acquisition_instrument_model  varchar(100))
;
