create table staging.metadata_metabolomics
(sample_id varchar(100)
,donor_id varchar(100)
,tissue_id varchar(100)
,execution_datetime varchar(100)
,protocols_io_doi varchar(100)
,operator varchar(100)
,operator_email varchar(100)
,pi varchar(100)
,pi_email varchar(100)
,assay_category varchar(100)
,assay_type varchar(100)
,analyte_class varchar(100)
,is_targeted varchar(100)
,acquisition_instrument_vendor varchar(100)
,acquisition_instrument_model varchar(100)
,metadata_path varchar(100)
,data_path varchar(100)
,ms_source varchar(100)
,polarity varchar(100)
,mass_range_low_value varchar(100)
,mass_range_high_value varchar(100)
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
,lc_length_value varchar(100)
,lc_length_unit varchar(100)
,lc_temp_value varchar(100)
,lc_temp_unit varchar(100)
,lc_id_value varchar(100)
,lc_id_unit varchar(100)
,lc_flow_rate_value varchar(100)
,lc_flow_rate_unit varchar(100)
,lc_gradient varchar(100)
,lc_mobile_phase_a varchar(100)
,lc_mobile_phase_b varchar(100)
,processing_search varchar(100)
,processing_protocols_io_doi varchar(100)
,overall_protocols_io_doi varchar(100))
;
