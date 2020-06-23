create table metadata.atacseq_bulk_hiseq
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
,bulk_atac_cell_isolation_protocols_io_doi varchar(100)
,nuclei_quality_metric varchar(100)
,bulk_transposition_input_number_nuclei integer
,transposition_method varchar(100)
,transposition_transposase_source varchar(100)
,transposition_kit_number varchar(100)  --not really a number; more of an operational key
,library_construction_protocols_io_doi varchar(100)
,library_layout varchar(100)
,library_adapter_sequence varchar(200)
,library_pcr_cycles integer
,library_average_fragment_size numeric(10,2)
,library_creation_date timestamp
,sequencing_reagent_kit varchar(100)
,sequencing_read_format varchar(100)
,sequencing_read_percent_q30 numeric(10,2)
,sequencing_phix_percent numeric(10,2)
,library_final_yield_value numeric(10,2)
,library_final_yield_units varchar(100)
,library_preparation_kit varchar(100)
,library_concentration_value numeric(10,2)
,library_concentration_unit varchar(100)
,metadata_path varchar(100)
,data_path varchar(100)
,fastqfilesize numeric(10,2))
;
