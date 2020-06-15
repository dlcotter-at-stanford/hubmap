create table metadata.atacseq_single_nucleus
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
