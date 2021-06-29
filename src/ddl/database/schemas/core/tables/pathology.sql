drop table if exists core.pathology_report
;
create table core.pathology_report
  (pathology_report_pk      serial primary key
  ,sample_pk                integer references core.sample(sample_pk)
  ,is_normal_tissue         boolean
  ,is_polyp                 boolean
  ,polyp_type               varchar(100)
  ,is_dysplastic            boolean
  ,has_high_dysplasia       boolean
  ,max_dysplasia            decimal(3,2)
  ,has_low_dysplasia        boolean
  ,min_dysplasia            decimal(3,2)
  ,pct_dysplastic_nuclei    decimal(3,2)
  ,pct_nondysplastic_stroma decimal(3,2)
  ,pct_dysplastic_tissue    decimal(3,2)
  ,pct_normal               decimal(3,2)
  ,pct_stroma               decimal(3,2)
  ,pct_cancer               decimal(3,2)
  ,pct_adenoma              decimal(3,2)
  ,pct_stroma_in_cancer     decimal(3,2)
  ,pct_stroma_in_adenoma    decimal(3,2)
  ,pct_necrosis_in_tumor    decimal(3,2)
  ,is_cancer                boolean
  ,cancer_type              varchar(100)
  ,cancer_grade             smallint)
;
