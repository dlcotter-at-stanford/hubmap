--ATAC-SEQ BULK-HISEQ
--truncate table metadata.atacseq_bulk_hiseq
--;
--insert into metadata.atacseq_bulk_hiseq
--  (sample_pk
--  ,study_donor_id
--  ,study_tissue_id
--  ,execution_datetime
--  ,protocols_io_doi
--  ,operator
--  ,operator_email
--  ,pi
--  ,pi_email
--  ,assay_category
--  ,assay_type
--  ,analyte_class
--  ,is_targeted
--  ,acquisition_instrument_vendor
--  ,acquisition_instrument_model
--  ,is_technical_replicate
--  ,library_id
--  ,bulk_atac_cell_isolation_protocols_io_doi
--  ,nuclei_quality_metric
--  ,bulk_transposition_input_number_nuclei
--  ,transposition_method
--  ,transposition_transposase_source
--  ,transposition_kit_number
--  ,library_construction_protocols_io_doi
--  ,library_layout
--  ,library_adapter_sequence
--  ,library_pcr_cycles
--  ,library_final_yield
--  ,library_final_yield_units
--  ,library_average_fragment_size
--  ,library_creation_date
--  ,sequencing_reagent_kit
--  ,sequencing_read_format
--  ,sequencing_read_percent_q30
--  ,sequencing_phix_percent
--  ,library_final_yield_value
--  ,library_final_yield_units
--  ,library_preparation_kit
--  ,library_concentration_value
--  ,library_concentration_unit
--  ,metadata_path
--  ,data_path
--  ,fastqfilesize)
--select
--   sample.sample_pk
--  ,donor_id
--  ,tissue_id
--  ,execution_datetime::timestamp
--  ,protocols_io_doi
--  ,operator
--  ,operator_email
--  ,pi
--  ,pi_email
--  ,assay_category
--  ,assay_type
--  ,analyte_class
--  ,is_targeted::boolean
--  ,acquisition_instrument_vendor
--  ,acquisition_instrument_model
--  ,is_technical_replicate::boolean
--  ,library_id
--  ,bulk_atac_cell_isolation_protocols_io_doi
--  ,nuclei_quality_metric
--  ,bulk_transposition_input_number_nuclei::integer
--  ,transposition_method
--  ,transposition_transposase_source
--  ,transposition_kit_number
--  ,library_construction_protocols_io_doi
--  ,library_layout
--  ,library_adapter_sequence
--  ,library_pcr_cycles::integer
--  ,library_final_yield::numeric(10,2)
--  ,library_final_yield_units
--  ,library_average_fragment_size::numeric(10,2)
--  ,library_creation_date::timestamp
--  ,sequencing_reagent_kit
--  ,sequencing_read_format
--  ,sequencing_read_percent_q30::numeric(10,2)
--  ,sequencing_phix_percent::numeric(10,2)
--  ,library_final_yield_value::numeric(10,2)
--  ,library_final_yield_units
--  ,library_preparation_kit
--  ,library_concentration_value::numeric(10,2)
--  ,library_concentration_unit
--  ,metadata_path
--  ,data_path
--  ,fastqfilesize::numeric(10,2)
--from staging.metadata_atacseq_bulk_hiseq
--join core.sample on sample.sample_bk = substring(sample_id,1,position('_' in sample_id)-1)
--;

--ATAC-SEQ SINGLE-NUCLEUS
truncate table metadata.atacseq_single_nucleus
;
insert into metadata.atacseq_single_nucleus
  (sample_pk 
  ,study_donor_id 
  ,study_tissue_id 
  ,execution_datetime
  ,protocols_io_doi 
  ,operator 
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
  ,data_path)
select
   sample.sample_pk
  ,donor_id
  ,tissue_id
  ,execution_datetime::timestamp
  ,protocols_io_doi
  ,operator
  ,operator_email
  ,pi
  ,pi_email
  ,assay_category
  ,assay_type
  ,analyte_class
  ,is_targeted::boolean
  ,acquisition_instrument_vendor
  ,acquisition_instrument_model
  ,is_technical_replicate::boolean
  ,library_id
  ,sc_isolation_protocols_io_doi
  ,sc_isolation_entity
  ,sc_isolation_tissue_dissociation
  ,sc_isolation_enrichment
  ,sc_isolation_quality_metric
  ,sc_isolation_cell_number::numeric(16,2)
  ,transposition_input::integer
  ,transposition_method
  ,transposition_transposase_source
  ,transposition_kit_number
  ,library_construction_protocols_io_doi
  ,library_layout
  ,library_adapter_sequence
  ,cell_barcode_read
  ,cell_barcode_offset::integer
  ,cell_barcode_size::integer
  ,library_pcr_cycles::integer
  ,library_pcr_cycles_for_sample_index::integer
  ,library_final_concentration::numeric(10,2)
  ,library_final_yield::numeric(10,2)
  ,library_final_yield_unit
  ,library_average_fragment_size::numeric(10,2)
  ,sequencing_reagent_kit
  ,sequencing_read_format
  ,sequencing_read_percent_q30::numeric(10,2)
  ,sequencing_phix_percent::numeric(10,2)
  ,metadata_path
  ,data_path
from staging.metadata_atacseq_single_nucleus
join core.sample on sample.sample_bk = sample_id
;

--LIPIDOMICS
truncate table metadata.lipidomics
;
insert into metadata.lipidomics
  (sample_pk
  ,study_donor_id
  ,study_tissue_id
  ,execution_datetime
  ,protocols_io_doi
  ,operator
  ,operator_email
  ,pi
  ,pi_email
  ,assay_category
  ,assay_type
  ,analyte_class
  ,is_targeted
  ,acquisition_instrument_vendor
  ,acquisition_instrument_model
  ,ms_source
  ,polarity
  ,mass_range_low_value
  ,mass_range_high_value
  ,mass_range_unit
  ,data_collection_mode
  ,ms_scan_mode
  ,labeling
  ,section_prep_protocols_io_doi
  ,lc_instrument_vendor
  ,lc_instrument_model
  ,lc_column_vendor
  ,lc_column_model
  ,lc_resin
  ,lc_length_value
  ,lc_length_unit
  ,lc_temp_value
  ,lc_temp_unit
  ,lc_id_value
  ,lc_id_unit
  ,lc_flow_rate_value
  ,lc_flow_rate_unit
  ,lc_gradient
  ,lc_mobile_phase_a
  ,lc_mobile_phase_b
  ,processing_search
  ,processing_protocols_io_doi
  ,overall_protocols_io_doi
  ,metadata_path
  ,data_path)
select
   sample.sample_pk
  ,donor_id
  ,tissue_id
  ,execution_datetime::timestamp
  ,protocols_io_doi
  ,operator
  ,operator_email
  ,pi
  ,pi_email
  ,assay_category
  ,assay_type
  ,analyte_class
  ,(case lower(is_targeted) when 'yes' then 'true' when 'no' then 'false' else is_targeted end)::boolean
  ,acquisition_instrument_vendor
  ,acquisition_instrument_model
  ,ms_source
  ,polarity
  ,nullif(lower(mass_range_low_value ), 'na')::numeric(10,2)
  ,nullif(lower(mass_range_high_value), 'na')::numeric(10,2)
  ,mass_range_unit
  ,nullif(lower(data_collection_mode), 'na')
  ,ms_scan_mode
  ,nullif(lower(labeling), 'no label')
  ,section_prep_protocols_io_doi
  ,lc_instrument_vendor
  ,lc_instrument_model
  ,nullif(lower(lc_column_vendor), 'na')
  ,nullif(lower(lc_column_model), 'na')
  ,nullif(lower(lc_resin), 'na')
  ,nullif(lower(lc_length_value), 'na')::numeric(10,2)
  ,nullif(lower(lc_length_unit), 'na')
  ,nullif(lower(lc_temp_value), 'na')::numeric(10,2)
  ,nullif(lower(lc_temp_unit), 'na')
  ,nullif(lower(lc_id_value), 'na')::numeric(10,2)
  ,nullif(lower(lc_id_unit), 'na')
  ,nullif(lower(lc_flow_rate_value), 'na')::numeric(10,2)
  ,nullif(lower(lc_flow_rate_unit), 'na')
  ,nullif(lower(lc_gradient), 'na')
  ,nullif(lower(lc_mobile_phase_a), 'na')
  ,nullif(lower(lc_mobile_phase_b), 'na')
  ,processing_search
  ,processing_protocols_io_doi
  ,overall_protocols_io_doi
  ,metadata_path
  ,data_path
from staging.metadata_lipidomics
join core.sample on sample.sample_bk = sample_id
;

--METABOLOMICS
truncate table metadata.metabolomics
;
insert into metadata.metabolomics
  (sample_pk
  ,study_donor_id
  ,study_tissue_id
  ,execution_datetime
  ,protocols_io_doi
  ,operator
  ,operator_email
  ,pi
  ,pi_email
  ,assay_category
  ,assay_type
  ,analyte_class
  ,is_targeted
  ,acquisition_instrument_vendor
  ,acquisition_instrument_model
  ,ms_source
  ,polarity
  ,mass_range_low_value
  ,mass_range_high_value
  ,mass_range_unit
  ,data_collection_mode
  ,ms_scan_mode
  ,labeling
  ,section_prep_protocols_io_doi
  ,lc_instrument_vendor
  ,lc_instrument_model
  ,lc_column_vendor
  ,lc_column_model
  ,lc_resin
  ,lc_length_value
  ,lc_length_unit
  ,lc_temp_value
  ,lc_temp_unit
  ,lc_id_value
  ,lc_id_unit
  ,lc_flow_rate_value
  ,lc_flow_rate_unit
  ,lc_gradient
  ,lc_mobile_phase_a
  ,lc_mobile_phase_b
  ,processing_search
  ,processing_protocols_io_doi
  ,overall_protocols_io_doi
  ,metadata_path
  ,data_path)
select
   sample.sample_pk
  ,donor_id
  ,tissue_id
  ,execution_datetime::timestamp
  ,protocols_io_doi
  ,operator
  ,operator_email
  ,pi
  ,pi_email
  ,assay_category
  ,assay_type
  ,analyte_class
  ,(case lower(is_targeted) when 'yes' then 'true' when 'no' then 'false' else is_targeted end)::boolean
  ,acquisition_instrument_vendor
  ,acquisition_instrument_model
  ,ms_source
  ,polarity
  ,mass_range_low_value::numeric(10,2)
  ,mass_range_high_value::numeric(10,2)
  ,mass_range_unit
  ,data_collection_mode
  ,ms_scan_mode
  ,labeling
  ,section_prep_protocols_io_doi
  ,lc_instrument_vendor
  ,lc_instrument_model
  ,lc_column_vendor
  ,lc_column_model
  ,lc_resin
  ,lc_length_value::numeric(10,2)
  ,lc_length_unit
  ,lc_temp_value::numeric(10,2)
  ,lc_temp_unit
  ,lc_id_value::numeric(10,2)
  ,lc_id_unit
  ,lc_flow_rate_value::numeric(10,2)
  ,lc_flow_rate_unit
  ,lc_gradient
  ,lc_mobile_phase_a
  ,lc_mobile_phase_b
  ,processing_search
  ,processing_protocols_io_doi
  ,overall_protocols_io_doi
  ,metadata_path
  ,data_path
from staging.metadata_metabolomics
join core.sample on sample.sample_bk = sample_id
;

--PROTEOMICS
insert into metadata.proteomics
  (sample_pk
  ,study_donor_id
  ,study_tissue_id
  ,execution_datetime
  ,protocols_io_doi
  ,operator
  ,operator_email
  ,pi
  ,pi_email
  ,assay_category
  ,assay_type
  ,analyte_class
  ,is_targeted
  ,acquisition_instrument_vendor
  ,acquisition_instrument_model
  ,ms_source
  ,polarity
  ,mass_range_low_value
  ,mass_range_high_value
  ,mass_range_unit
  ,data_collection_mode
  ,ms_scan_mode
  ,labeling
  ,section_prep_protocols_io_doi
  ,lc_instrument_vendor
  ,lc_instrument_model
  ,lc_column_vendor
  ,lc_column_model
  ,lc_resin
  ,lc_length_value
  ,lc_length_unit
  ,lc_temp_value
  ,lc_temp_unit
  ,lc_id_value
  ,lc_id_unit
  ,lc_flow_rate
  ,lc_flow_rate_unit
  ,lc_gradient
  ,lc_mobile_phase_a
  ,lc_mobile_phase_b
  ,processing_search
  ,processing_protocols_io_doi
  ,overall_protocols_io_doi
  ,metadata_path
  ,data_path)
select
   sample.sample_pk
  ,donor_id
  ,tissue_id
  ,execution_datetime::timestamp
  ,protocols_io_doi
  ,operator
  ,operator_email
  ,pi
  ,pi_email
  ,assay_category
  ,assay_type
  ,analyte_class
  ,is_targeted::boolean
  ,acquisition_instrument_vendor
  ,acquisition_instrument_model
  ,ms_source
  ,polarity
  ,mass_range_low_value::numeric(10,2)
  ,mass_range_high_value::numeric(10,2)
  ,mass_range_unit
  ,data_collection_mode
  ,ms_scan_mode
  ,labeling
  ,section_prep_protocols_io_doi
  ,lc_instrument_vendor
  ,lc_instrument_model
  ,lc_column_vendor
  ,lc_column_model
  ,lc_resin
  ,lc_length_value::numeric(10,2)
  ,lc_length_unit
  ,lc_temp_value::numeric(10,2)
  ,lc_temp_unit
  ,lc_id_value::numeric(10,2)
  ,lc_id_unit
  ,lc_flow_rate::numeric(10,2)
  ,lc_flow_rate_unit
  ,lc_gradient
  ,lc_mobile_phase_a
  ,lc_mobile_phase_b
  ,processing_search
  ,processing_protocols_io_doi
  ,overall_protocols_io_doi
  ,metadata_path
  ,data_path
from staging.metadata_proteomics
join core.sample on sample.sample_bk = sample_id
;

--RNA-SEQ BULK
insert into metadata.rnaseq_bulk
  (sample_pk
  ,study_donor_id
  ,study_tissue_id
  ,execution_datetime
  ,protocols_io_doi
  ,operator
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
  ,scg_path)
select
   sample.sample_pk
  ,donor_id
  ,tissue_id
  ,execution_datetime::timestamp
  ,protocols_io_doi
  ,operator
  ,operator_email
  ,pi
  ,pi_email
  ,assay_category
  ,assay_type
  ,analyte_class
  ,is_targeted::boolean
  ,acquisition_instrument_vendor
  ,acquisition_instrument_model
  ,bulk_rna_isolation_protocols_io_doi
  ,bulk_rna_yield_value::numeric(10,2)
  ,bulk_rna_yield_units_per_tissue_unit
  ,bulk_rna_isolation_quality_metric_value
  ,rnaseq_assay_input_value::numeric(10,2)
  ,rnaseq_assay_input_unit
  ,rnaseq_assay_method
  ,library_construction_protocols_io_doi
  ,library_layout
  ,library_adapter_sequence
  ,library_pcr_cycles_for_sample_index
  ,library_final_yield_value::numeric(10,2)
  ,library_final_yield_unit
  ,library_average_fragment_size::numeric(10,2)
  ,sequencing_reagent_kit
  ,sequencing_read_format
  ,sequencing_read_percent_q30::numeric(10,2)
  ,sequencing_phix_percent::numeric(10,2)
  ,metadata_path
  ,data_path
  ,scg_path
from staging.metadata_rnaseq_bulk
join core.sample on sample.sample_bk = sample_id
;

--RNA-SEQ SINGLE-NUCLEUS
insert into metadata.rnaseq_single_nucleus
  (sample_pk
  ,study_donor_id
  ,study_tissue_id
  ,execution_datetime
  ,protocols_io_doi
  ,operator
  ,operator_email
  ,pi
  ,pi_email
  ,assay_category
  ,assay_type
  ,analyte_class
  ,is_targeted
  ,acquisition_instrument_vendor
  ,acquisition_instrument_model
  ,sc_isolation_protocols_io_doi
  ,sc_isolation_entity
  ,sc_isolation_tissue_dissociation
  ,sc_isolation_enrichment
  ,sc_isolation_quality_metric
  ,sc_isolation_cell_number
  ,rnaseq_assay_input
  ,rnaseq_assay_method
  ,library_construction_protocols_io_doi
  ,library_layout
  ,library_adapter_sequence
  ,cell_barcode_read
  ,cell_barcode_offset
  ,cell_barcode_size
  ,library_pcr_cycles
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
  ,kit_version_10x)
select
   sample_pk
  ,donor_id
  ,tissue_id
  ,execution_datetime::timestamp
  ,protocols_io_doi
  ,operator
  ,operator_email
  ,pi
  ,pi_email
  ,assay_category
  ,assay_type
  ,analyte_class
  ,(case lower(is_targeted) when 'yes' then 'true' when 'no' then 'false' else is_targeted end)::boolean
  ,acquisition_instrument_vendor
  ,acquisition_instrument_model
  ,sc_isolation_protocols_io_doi
  ,sc_isolation_entity
  ,sc_isolation_tissue_dissociation
  ,sc_isolation_enrichment
  ,sc_isolation_quality_metric
  ,sc_isolation_cell_number::integer
  ,rnaseq_assay_input
  ,rnaseq_assay_method
  ,library_construction_protocols_io_doi
  ,library_layout
  ,library_adapter_sequence
  ,cell_barcode_read
  ,cell_barcode_offset::integer
  ,cell_barcode_size::integer
  ,library_pcr_cycles::integer
  ,library_pcr_cycles_for_sample_index::integer
  ,library_final_yield_value::numeric(10,2)
  ,library_final_yield_unit
  ,library_average_fragment_size::numeric(10,2)
  ,sequencing_reagent_kit
  ,sequencing_read_format
  ,sequencing_read_percent_q30::numeric(10,2)
  ,sequencing_phix_percent::numeric(10,2)
  ,metadata_path
  ,data_path
  ,kit_version_10x
from staging.metadata_rnaseq_single_nucleus
join core.sample on sample.sample_bk = sample_id
;

--WHOLE-GENOME SEQUENCING
insert into metadata.whole_genome_seq
  (sample_pk
  ,study_donor_id
  ,study_tissue_id
  ,execution_datetime
  ,protocols_io_doi
  ,operator
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
  ,data_path)
select
   sample.sample_pk
  ,donor_id
  ,tissue_id
  ,execution_datetime::timestamp
  ,sequencing_protocols_io_doi
  ,operator
  ,operator_email
  ,pi
  ,pi_email
  ,assay_category
  ,assay_type
  ,analyte_class
  ,(case lower(is_targeted) when 'yes' then 'true' when 'no' then 'false' end)::boolean
  ,acquisition_instrument_vendor
  ,acquisition_instrument_model
  ,gdna_fragmentation_quality_assurance
  ,dna_assay_input_ugrams::numeric(10,2)
  ,library_construction_method
  ,library_construction_protocols_io_doi
  ,library_layout
  ,library_adapter_sequence
  ,library_final_yield_ng::numeric(10,2)
  ,library_average_fragment_size::numeric(10,2)
  ,sequencing_reagent_kit
  ,sequencing_read_format
  ,sequencing_read_percent_q30::numeric(10,2)
  ,sequencing_phix_percent::numeric(10,2)
  ,novogene_id
  ,metadata_path
  ,data_path
from staging.metadata_whole_genome_seq
join core.sample on sample.sample_bk = internal_id
;
/* --on hold
--RNA-SEQ SINGLE-NUCLEUS ADDITIONAL
insert into metadata.rnaseq_single_nucleus
  (sample_pk
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
  ,sc_isolation_protocols_io_doi
  ,sc_isolation_entity
  ,sc_isolation_tissue_dissociation
  ,sc_isolation_enrichment
  ,sc_isolation_quality_metric
  ,sc_isolation_cell_number
  ,rnaseq_assay_input
  ,rnaseq_assay_method
  ,library_construction_protocols_io_doi
  ,library_layout
  ,library_adapter_sequence
  ,cell_barcode_read
  ,cell_barcode_offset
  ,cell_barcode_size
  ,library_pcr_cycles
  ,library_pcr_cycles_for_sample_index
  ,library_final_yield
  ,library_average_fragment_size
  ,sequencing_reagent_kit
  ,sequencing_read_format
  ,sequencing_read_percent_q30
  ,sequencing_phix_percent
  ,metadata_path
  ,data_path)
select
   experiment_date
  ,sample
  ,tissue_preservation_method
  ,tissue_location
  ,tissue_phenotype
  ,amt_used_mg
  ,protocol
  ,dissociation_method
  ,dissociation_buffer
  ,note
  ,snrnaseq
  ,yield
  ,target_recovery_and_10x_cell_concentration
  ,cdna_conc
  ,kit_version_10x
  ,sequencing_submission
  ,sequencing_parameters
  ,pass_qc
  ,snrnaseq_library_created
  ,snrnaseq_library_sequenced
  ,snrnaseq_data_quality
  ,snatacseq
  ,snatacseq_library_created
  ,snatacseq_library_sequenced
  ,snatacseq_data_quality

*/
