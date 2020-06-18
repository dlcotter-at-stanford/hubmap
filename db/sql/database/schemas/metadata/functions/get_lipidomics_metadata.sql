create or replace function metadata.get_lipidomics_metadata(p_subject_bk varchar(100), p_sample_bk varchar(100))
returns table
	(sample_bk varchar(100)
	,hubmap_donor_id varchar(100)
	,hubmap_tissue_id varchar(100)
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
     sample_bk
    ,hubmap_donor_id
    ,hubmap_tissue_id
    ,execution_datetime
    ,protocols_io_doi
    ,"operator"
    ,operator_email
    ,pi
    ,pi_email
    ,assay_category
    ,assay_type
    ,analyte_class
    ,is_targeted
    ,acquisition_instrument_vendor
    ,acquisition_instrument_model
    ,ms_source
    ,polarity
    ,mass_range_low_value
    ,mass_range_high_value
    ,mass_range_unit
    ,data_collection_mode
    ,ms_scan_mode
    ,labeling
    ,section_prep_protocols_io_doi
    ,lc_instrument_vendor
    ,lc_instrument_model
    ,lc_column_vendor
    ,lc_column_model
    ,lc_resin
    ,lc_length_value
    ,lc_length_unit
    ,lc_temp_value
    ,lc_temp_unit
    ,lc_id_value
    ,lc_id_unit
    ,lc_flow_rate_value
    ,lc_flow_rate_unit
    ,lc_gradient
    ,lc_mobile_phase_a
    ,lc_mobile_phase_b
    ,processing_search
    ,processing_protocols_io_doi
    ,overall_protocols_io_doi
    ,metadata_path
    ,data_path
  from metadata.lipidomics md
  join core.sample on sample.sample_pk = md.sample_pk
  join core.subject on subject.subject_pk = sample.subject_pk
  where (p_subject_bk is null or subject.subject_bk = p_subject_bk)
  and (p_sample_bk is null or sample.sample_bk = p_sample_bk)
$$

