create or replace function metadata.get_atacseq_bulk_hiseq_metadata(p_subject_bk varchar(100), p_sample_bk varchar(100))
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
	,bulk_atac_cell_isolation_protocols_io_doi varchar(100)
	,nuclei_quality_metric varchar(100)
	,bulk_transposition_input_number_nuclei integer
	,transposition_method varchar(100)
	,transposition_transposase_source varchar(100)
	,transposition_kit_number varchar(100)
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
    ,bulk_atac_cell_isolation_protocols_io_doi
    ,nuclei_quality_metric
    ,bulk_transposition_input_number_nuclei
    ,transposition_method
    ,transposition_transposase_source
    ,transposition_kit_number
    ,library_construction_protocols_io_doi
    ,library_layout
    ,library_adapter_sequence
    ,library_pcr_cycles
    ,library_average_fragment_size
    ,library_creation_date
    ,sequencing_reagent_kit
    ,sequencing_read_format
    ,sequencing_read_percent_q30
    ,sequencing_phix_percent
    ,library_final_yield_value
    ,library_final_yield_units
    ,library_preparation_kit
    ,library_concentration_value
    ,library_concentration_unit
    ,metadata_path
    ,data_path
    ,fastqfilesize
  from metadata.atacseq_bulk_hiseq md
  join core.sample on sample.sample_pk = md.sample_pk
  join core.subject on subject.subject_pk = sample.subject_pk
  where (p_subject_bk is null or subject.subject_bk = p_subject_bk)
  and (p_sample_bk is null or sample.sample_bk = p_sample_bk)
$$

