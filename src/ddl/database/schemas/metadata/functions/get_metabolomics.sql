create or replace function metadata.get_metabolomics
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
	,ms_source varchar(100)
	,polarity varchar(100)
	,mass_range_low_value numeric(10,2)
	,mass_range_high_value numeric(10,2)
	,mass_range_unit varchar(100)
	,data_collection_mode varchar(100)
	,ms_scan_mode varchar(100)
	,labeling varchar(100)
	,section_prep_protocols_io_doi varchar(100)
	,lc_instrument_vendor varchar(100)
	,lc_instrument_model varchar(100)
	,lc_column_vendor varchar(100)
	,lc_column_model varchar(100)
	,lc_resin varchar(100)
	,lc_length_value numeric(10,2)
	,lc_length_unit varchar(100)
	,lc_temp_value numeric(10,2)
	,lc_temp_unit varchar(100)
	,lc_id_value numeric(10,2)
	,lc_id_unit varchar(100)
	,lc_flow_rate_value numeric(10,2)
	,lc_flow_rate_unit varchar(100)
	,lc_gradient varchar(100)
	,lc_mobile_phase_a varchar(100)
	,lc_mobile_phase_b varchar(100)
	,processing_search varchar(100)
	,processing_protocols_io_doi varchar(100)
	,overall_protocols_io_doi varchar(100)
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
    ,md.ms_source
    ,md.polarity
    ,md.mass_range_low_value
    ,md.mass_range_high_value
    ,md.mass_range_unit
    ,md.data_collection_mode
    ,md.ms_scan_mode
    ,md.labeling
    ,md.section_prep_protocols_io_doi
    ,md.lc_instrument_vendor
    ,md.lc_instrument_model
    ,md.lc_column_vendor
    ,md.lc_column_model
    ,md.lc_resin
    ,md.lc_length_value
    ,md.lc_length_unit
    ,md.lc_temp_value
    ,md.lc_temp_unit
    ,md.lc_id_value
    ,md.lc_id_unit
    ,md.lc_flow_rate_value
    ,md.lc_flow_rate_unit
    ,md.lc_gradient
    ,md.lc_mobile_phase_a
    ,md.lc_mobile_phase_b
    ,md.processing_search
    ,md.processing_protocols_io_doi
    ,md.overall_protocols_io_doi
    ,md.metadata_path
    ,md.data_path
  from metadata.metabolomics md
  join core.sample on sample.sample_pk = md.sample_pk
  join core.subject on subject.subject_pk = sample.subject_pk
  join core.study on study.study_pk = subject.study_pk
  where (p_study_bk is null or study.study_bk = p_study_bk)
  and (p_subject_bk is null or subject.subject_bk = p_subject_bk)
  and (p_sample_bk is null or sample.sample_bk = p_sample_bk)
$$

