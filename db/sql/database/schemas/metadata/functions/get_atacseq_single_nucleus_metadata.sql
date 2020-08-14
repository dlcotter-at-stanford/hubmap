create or replace function metadata.get_atacseq_single_nucleus_metadata(p_subject_bk varchar(100) default null, p_sample_bk varchar(100) default null)
returns table
	(sample_bk varchar(100)
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
language sql
as $$
  select
     sample_bk
    ,study_donor_id
    ,study_tissue_id
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
    ,is_technical_replicate
    ,library_id
    ,sc_isolation_protocols_io_doi
    ,sc_isolation_entity
    ,sc_isolation_tissue_dissociation
    ,sc_isolation_enrichment
    ,sc_isolation_quality_metric
    ,sc_isolation_cell_number
    ,transposition_input
    ,transposition_method
    ,transposition_transposase_source
    ,transposition_kit_number
    ,library_construction_protocols_io_doi
    ,library_layout
    ,library_adapter_sequence
    ,cell_barcode_read
    ,cell_barcode_offset
    ,cell_barcode_size
    ,library_pcr_cycles
    ,library_pcr_cycles_for_sample_index
    ,library_final_concentration
    ,library_final_yield
    ,library_final_yield_unit
    ,library_average_fragment_size
    ,sequencing_reagent_kit
    ,sequencing_read_format
    ,sequencing_read_percent_q30
    ,sequencing_phix_percent
    ,metadata_path
    ,data_path
  from metadata.atacseq_single_nucleus md
  join core.sample on sample.sample_pk = md.sample_pk
  join core.subject on subject.subject_pk = sample.subject_pk
  where (p_subject_bk is null or subject.subject_bk = p_subject_bk)
  and (p_sample_bk is null or sample.sample_bk = p_sample_bk)
$$

