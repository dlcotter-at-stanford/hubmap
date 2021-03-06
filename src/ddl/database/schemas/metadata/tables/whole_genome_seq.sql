create table metadata.whole_genome_seq
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
,gdna_fragmentation_quality_assurance varchar(100)
,dna_assay_input_ugrams numeric(10,2)
,library_construction_method varchar(100)
,library_construction_protocols_io_doi varchar(100)
,library_layout varchar(100)
,library_adapter_sequence varchar(200)
,library_final_yield_ng numeric(10,2)
,library_average_fragment_size numeric(10,2)
,sequencing_reagent_kit varchar(100)
,sequencing_read_format varchar(100)
,sequencing_read_percent_q30 numeric(10,2)
,sequencing_phix_percent numeric(10,2)
,novogene_id varchar(100)
,metadata_path varchar(100)
,data_path varchar(100))
