create or replace function metadata.get_whole_genome_seq_metadata(p_subject_bk varchar(100), p_sample_bk varchar(100))
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
    ,gdna_fragmentation_quality_assurance
    ,dna_assay_input_ugrams
    ,library_construction_method
    ,library_construction_protocols_io_doi
    ,library_layout
    ,library_adapter_sequence
    ,library_final_yield_ng
    ,library_average_fragment_size
    ,sequencing_reagent_kit
    ,sequencing_read_format
    ,sequencing_read_percent_q30
    ,sequencing_phix_percent
    ,novogene_id
    ,metadata_path
    ,data_path
  from metadata.whole_genome_seq md
  join core.sample on sample.sample_pk = md.sample_pk
  join core.subject on subject.subject_pk = sample.subject_pk
  where (p_subject_bk is null or subject.subject_bk = p_subject_bk)
  and (p_sample_bk is null or sample.sample_bk = p_sample_bk)
$$

