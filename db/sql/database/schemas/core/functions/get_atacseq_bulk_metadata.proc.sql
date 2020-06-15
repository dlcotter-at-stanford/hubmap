drop function if exists get_atacseq_bulk_metadata(character varying)
;
create or replace
function reporting.get_atacseq_bulk_metadata
	(p_subject_bk varchar(100)
	,has_coordinates boolean default false)
returns table
  (sample_bk                                  varchar(100)
  ,hubmap_subject_bk                          varchar(100)
  ,hubmap_tissue_bk                           varchar(100)
  ,execution_datetime                         timestamp
  ,protocols_io_doi                           varchar(100)
  ,operator                                   varchar(100)
  ,operator_email                             varchar(100)
  ,pi                                         varchar(100)
  ,pi_email                                   varchar(100)
  ,assay_category                             varchar(100)
  ,assay_type                                 varchar(100)
  ,analyte_class                              varchar(100)
  ,is_targeted                                boolean
  ,acquisition_instrument_vendor              varchar(100)
  ,acquisition_instrument_model               varchar(100)
  ,is_technical_replicate                     boolean
  ,library_id                                 varchar(100)
  ,bulk_atac_cell_isolation_protocols_io_doi  varchar(100)
  ,nuclei_quality_metric                      varchar(100)
  ,bulk_transposition_input_number_nuclei     integer
  ,transposition_method                       varchar(100)
  ,transposition_transposase_source           varchar(100)
  ,transposition_kit_number                   integer
  ,library_construction_protocols_io_doi      varchar(100)
  ,library_layout                             varchar(100)
  ,library_adapter_sequence                   varchar(200)
  ,library_pcr_cycles                         integer
  ,library_average_fragment_size              numeric(7,3)
  ,library_creation_date                      date
  ,sequencing_reagent_kit                     varchar(100)
  ,sequencing_read_format                     varchar(100)
  ,sequencing_read_percent_q30                numeric(7,3)
  ,sequencing_phix_percent                    numeric(7,3)
  ,library_final_yield_value                  numeric(7,3)
  ,library_final_yield_units                  varchar(100)
  ,library_preparation_kit                    varchar(100)
  ,library_concentration_value                numeric(7,3)
  ,library_concentration_unit                 varchar(100)
  ,metadata_path                              varchar(100)
  ,data_path                                  varchar(100)
  ,fastq_file_size                            varchar(100)
)
language sql
as
$$
select 
   sample_bk
  ,hubmap_subject_bk
  ,hubmap_tissue_bk
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
  ,fastq_file_size
from staging.atacseq_bulk_metadata
where subject.subject_bk = p_subject_bk
and
	 --get all records without regard to presence of coordinates
	(has_coordinates is null

	 --only get records with coordinates
	 or (has_coordinates is true
		 and sample.x_coord is not null
		 and sample.y_coord is not null)

	 --only get records without coordinates
	 or (has_coordinates is false
		 and sample.x_coord is null
		 and sample.y_coord is null))
$$
