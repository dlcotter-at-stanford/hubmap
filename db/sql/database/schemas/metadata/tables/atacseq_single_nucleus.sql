create table metadata.atacseq_single_nucleus
(metadata_pk serial primary key
,sample_pk integer references core.sample(sample_pk)
,study_donor_id varchar(100)
,study_tissue_id varchar(100)
,execution_datetime timestamp
,protocols_io_doi varchar(100)
,operator varchar(100)
,operator_email varchar(100)
,pi varchar(100)
,pi_email varchar(100)
,assay_category varchar(100)
,assay_type varchar(100)
,analyte_class varchar(100)
,is_targeted boolean
,acquisition_instrument_vendor varchar(100)
,acquisition_instrument_model varchar(100)
,is_technical_replicate boolean
,library_id varchar(100)
,sc_isolation_protocols_io_doi varchar(100)
,sc_isolation_entity varchar(100)
,sc_isolation_tissue_dissociation varchar(100)
,sc_isolation_enrichment varchar(100)
,sc_isolation_quality_metric varchar(100)
,sc_isolation_cell_number numeric(8,2)
,transposition_input integer
,transposition_method varchar(100)
,transposition_transposase_source varchar(100)
,transposition_kit_number varchar(100)
,library_construction_protocols_io_doi varchar(100)
,library_layout varchar(100)
,library_adapter_sequence varchar(100)
,cell_barcode_read varchar(100)
,cell_barcode_offset integer
,cell_barcode_size integer
,library_pcr_cycles integer
,library_pcr_cycles_for_sample_index integer
,library_final_concentration numeric(10,2)
,library_final_yield numeric(10,2)
,library_final_yield_unit varchar(100)
,library_average_fragment_size numeric(10,2)
,sequencing_reagent_kit varchar(100)
,sequencing_read_format varchar(100)
,sequencing_read_percent_q30 numeric(10,2)
,sequencing_phix_percent numeric(10,2)
,metadata_path varchar(100)
,data_path varchar(100))
;
