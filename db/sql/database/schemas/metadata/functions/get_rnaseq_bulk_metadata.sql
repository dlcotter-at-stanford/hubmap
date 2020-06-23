create or replace function metadata.get_rnaseq_bulk_metadata(p_subject_bk varchar(100), p_sample_bk varchar(100))
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
	,bulk_rna_isolation_protocols_io_doi varchar(100)
	,bulk_rna_yield_value numeric(10,2)
	,bulk_rna_yield_units_per_tissue_unit varchar(100)
	,bulk_rna_isolation_quality_metric_value varchar(100)
	,rnaseq_assay_input_value numeric(10,2)
	,rnaseq_assay_input_unit varchar(100)
	,rnaseq_assay_method varchar(100)
	,library_construction_protocols_io_doi varchar(100)
	,library_layout varchar(100)
	,library_adapter_sequence varchar(200)
	,library_pcr_cycles_for_sample_index varchar(100)
	,library_final_yield_value numeric(10,2)
	,library_final_yield_unit varchar(100)
	,library_average_fragment_size numeric(10,2)
	,sequencing_reagent_kit varchar(100)
	,sequencing_read_format varchar(100)
	,sequencing_read_percent_q30 varchar(100)
	,sequencing_phix_percent varchar(100)
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
    ,bulk_rna_isolation_protocols_io_doi
    ,bulk_rna_yield_value
    ,bulk_rna_yield_units_per_tissue_unit
    ,bulk_rna_isolation_quality_metric_value
    ,rnaseq_assay_input_value
    ,rnaseq_assay_input_unit
    ,rnaseq_assay_method
    ,library_construction_protocols_io_doi
    ,library_layout
    ,library_adapter_sequence
    ,library_pcr_cycles_for_sample_index
    ,library_final_yield_value
    ,library_final_yield_unit
    ,library_average_fragment_size
    ,sequencing_reagent_kit
    ,sequencing_read_format
    ,sequencing_read_percent_q30
    ,sequencing_phix_percent
    ,metadata_path
    ,data_path
  from metadata.rnaseq_bulk md
  join core.sample on sample.sample_pk = md.sample_pk
  join core.subject on subject.subject_pk = sample.subject_pk
  where (p_subject_bk is null or subject.subject_bk = p_subject_bk)
  and (p_sample_bk is null or sample.sample_bk = p_sample_bk)
$$

