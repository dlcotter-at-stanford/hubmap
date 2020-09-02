create or replace function metadata.get_rnaseq_bulk
  (p_study_bk   varchar(100) default null
  ,p_subject_bk varchar(100) default null
  ,p_sample_bk  varchar(100) default null)
returns table
	(study_bk varchar(100)
	,subject_bk varchar(100)
	,sample_bk varchar(100)
	,study_donor_id varchar(100)
	,study_tissue_id varchar(100)
	,execution_datetime timestamp
	,protocols_io_doi varchar(100)
	,"operator" varchar(100)
	,operator_email varchar(100)
	,pi varchar(100)
	,pi_email varchar(100)
	,assay_category varchar(100)
	,assay_type varchar(100)
	,analyte_class varchar(100)
	,is_targeted boolean
	,acquisition_instrument_vendor varchar(100)
	,acquisition_instrument_model varchar(100)
	,bulk_rna_isolation_protocols_io_doi varchar(100)
	,bulk_rna_yield_value numeric(10,2)
	,bulk_rna_yield_units_per_tissue_unit varchar(100)
	,bulk_rna_isolation_quality_metric_value varchar(100)
	,rnaseq_assay_input_value numeric(10,2)
	,rnaseq_assay_input_unit varchar(100)
	,rnaseq_assay_method varchar(100)
	,library_construction_protocols_io_doi varchar(100)
	,library_layout varchar(100)
	,library_adapter_sequence varchar(200)
	,library_pcr_cycles_for_sample_index varchar(100)
	,library_final_yield_value numeric(10,2)
	,library_final_yield_unit varchar(100)
	,library_average_fragment_size numeric(10,2)
	,sequencing_reagent_kit varchar(100)
	,sequencing_read_format varchar(100)
	,sequencing_read_percent_q30 varchar(100)
	,sequencing_phix_percent varchar(100)
	,metadata_path varchar(100)
	,data_path varchar(100))
language sql
as $$
  select
     study.study_bk
    ,subject.subject_bk
    ,sample.sample_bk
    ,md.study_donor_id
    ,md.study_tissue_id
    ,md.execution_datetime
    ,md.protocols_io_doi
    ,md."operator"
    ,md.operator_email
    ,md.pi
    ,md.pi_email
    ,md.assay_category
    ,md.assay_type
    ,md.analyte_class
    ,md.is_targeted
    ,md.acquisition_instrument_vendor
    ,md.acquisition_instrument_model
    ,md.bulk_rna_isolation_protocols_io_doi
    ,md.bulk_rna_yield_value
    ,md.bulk_rna_yield_units_per_tissue_unit
    ,md.bulk_rna_isolation_quality_metric_value
    ,md.rnaseq_assay_input_value
    ,md.rnaseq_assay_input_unit
    ,md.rnaseq_assay_method
    ,md.library_construction_protocols_io_doi
    ,md.library_layout
    ,md.library_adapter_sequence
    ,md.library_pcr_cycles_for_sample_index
    ,md.library_final_yield_value
    ,md.library_final_yield_unit
    ,md.library_average_fragment_size
    ,md.sequencing_reagent_kit
    ,md.sequencing_read_format
    ,md.sequencing_read_percent_q30
    ,md.sequencing_phix_percent
    ,md.metadata_path
    ,md.data_path
  from metadata.rnaseq_bulk md
  join core.sample on sample.sample_pk = md.sample_pk
  join core.subject on subject.subject_pk = sample.subject_pk
  join core.study on study.study_pk = subject.study_pk
  where (p_study_bk is null or study.study_bk = p_study_bk)
  and (p_subject_bk is null or subject.subject_bk = p_subject_bk)
  and (p_sample_bk is null or sample.sample_bk = p_sample_bk)
$$

