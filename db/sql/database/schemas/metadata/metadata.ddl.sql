create table staging.metadata_acatacseq_bulk_hiseq
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
,is_technical_replicate varchar(100)
,library_id varchar(100)
,bulk_atac_cell_isolation_protocols_io_doi varchar(100)
,nuclei_quality_metric varchar(100)
,bulk_transposition_input_number_nuclei varchar(100)
,transposition_method varchar(100)
,transposition_transposase_source varchar(100)
,transposition_kit_number varchar(100)
,library_construction_protocols_io_doi varchar(100)
,library_layout varchar(100)
,library_adapter_sequence varchar(100)
,library_pcr_cycles varchar(100)
,library_average_fragment_size varchar(100)
,library_creation_date varchar(100)
,sequencing_reagent_kit varchar(100)
,sequencing_read_format varchar(100)
,sequencing_read_percent_q30 varchar(100)
,sequencing_phix_percent varchar(100)
,library_final_yield_value varchar(100)
,library_final_yield_units varchar(100)
,library_preparation_kit varchar(100)
,library_concentration_value varchar(100)
,library_concentration_unit varchar(100)
,fastqfilesize varchar(100))
;
create table staging.metadata_atacseq_single_nucleus
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
,is_technical_replicate varchar(100)
,library_id varchar(100)
,sc_isolation_protocols_io_doi varchar(100)
,sc_isolation_entity varchar(100)
,sc_isolation_tissue_dissociation varchar(100)
,sc_isolation_enrichment varchar(100)
,sc_isolation_quality_metric varchar(100)
,sc_isolation_cell_number varchar(100)
,transposition_input varchar(100)
,transposition_method varchar(100)
,transposition_transposase_source varchar(100)
,transposition_kit_number varchar(100)
,library_construction_protocols_io_doi varchar(100)
,library_layout varchar(100)
,library_adapter_sequence varchar(100)
,cell_barcode_read varchar(100)
,cell_barcode_offset varchar(100)
,cell_barcode_size varchar(100)
,library_pcr_cycles varchar(100)
,library_pcr_cycles_for_sample_index varchar(100)
,library_final_concentration varchar(100)
,library_final_yield varchar(100)
,library_final_yield_unit varchar(100)
,library_average_fragment_size varchar(100)
,sequencing_reagent_kit varchar(100)
,sequencing_read_format varchar(100)
,sequencing_read_percent_q30 varchar(100)
,sequencing_phix_percent varchar(100))
;
create table staging.metadata_lipidomics
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
create table staging.metadata_proteomics
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
,lc_flow_rate varchar(100)
,lc_flow_rate_unit varchar(100)
,lc_gradient varchar(100)
,lc_mobile_phase_a varchar(100)
,lc_mobile_phase_b varchar(100)
,processing_search varchar(100)
,processing_protocols_io_doi varchar(100)
,overall_protocols_io_doi varchar(100))
;
create table staging.metadata_rnaseq_bulk
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
,bulk_rna_isolation_protocols_io_doi varchar(100)
,bulk_rna_yield_value varchar(100)
,bulk_rna_yield_units_per_tissue_unit varchar(100)
,bulk_rna_isolation_quality_metric_value varchar(100)
,rnaseq_assay_input_value varchar(100)
,rnaseq_assay_input_unit varchar(100)
,rnaseq_assay_method varchar(100)
,library_construction_protocols_io_doi varchar(100)
,library_layout varchar(100)
,library_adapter_sequence varchar(100)
,library_pcr_cycles_for_sample_index varchar(100)
,library_final_yield_value varchar(100)
,library_final_yield_unit varchar(100)
,library_average_fragment_size varchar(100)
,sequencing_reagent_kit varchar(100)
,sequencing_read_format varchar(100)
,sequencing_read_percent_q30 varchar(100)
,sequencing_phix_percent varchar(100))
;
create table staging.metadata_rnaseq_single_nucleus
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
,sc_isolation_protocols_io_doi varchar(100)
,sc_isolation_entity varchar(100)
,sc_isolation_tissue_dissociation varchar(100)
,sc_isolation_enrichment varchar(100)
,sc_isolation_quality_metric varchar(100)
,sc_isolation_cell_number varchar(100)
,rnaseq_assay_input varchar(100)
,rnaseq_assay_method varchar(100)
,library_construction_protocols_io_doi varchar(100)
,library_layout varchar(100)
,library_adapter_sequence varchar(100)
,cell_barcode_read varchar(100)
,cell_barcode_offset varchar(100)
,cell_barcode_size varchar(100)
,library_pcr_cycles varchar(100)
,library_pcr_cycles_for_sample_index varchar(100)
,library_final_yield varchar(100)
,library_average_fragment_size varchar(100)
,sequencing_reagent_kit varchar(100)
,sequencing_read_format varchar(100)
,sequencing_read_percent_q30 varchar(100)
,sequencing_phix_percent varchar(100))
;
create table staging.metadata_wgs
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
,gdna_fragmentation_quality_assurance varchar(100)
,dna_assay_input_ugrams varchar(100)
,library_construction_method varchar(100)
,library_construction_protocols_io_doi varchar(100)
,library_layout varchar(100)
,library_adapter_sequence varchar(100)
,library_final_yield_ng varchar(100)
,library_average_fragment_size varchar(100)
,sequencing_reagent_kit varchar(100)
,sequencing_read_format varchar(100)
,sequencing_read_percent_q30 varchar(100)
,sequencing_phix_percent varchar(100)
,novogene_id varchar(100))
