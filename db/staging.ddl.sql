--> connect to hubmap database
;
drop schema if exists staging cascade
;
create schema staging
;
create table staging.sample_tracker_stg
  (sample_name            varchar(100)
  ,patient                varchar(100)
  ,building               varchar(100)
  ,freezer                varchar(100)
  ,rack                   varchar(100)
  ,box_name               varchar(100)
  ,collection             varchar(100)
  ,amt_mg                 varchar(100)
  ,amt_ul                 varchar(100)
  ,preservation_method    varchar(100)
  ,current_state          varchar(100)
  ,donor_disease_status   varchar(100)
  ,stage                  varchar(100)
  ,phenotype              varchar(100)
  ,sample_location        varchar(100)
  ,size_mm                varchar(100)
  ,dna_wgs                varchar(100)
  ,dna_wes                varchar(100)
  ,wg_bisulfite           varchar(100)
  ,rna_seq                varchar(100)
  ,bulk_atac              varchar(100)
  ,single_gland_atac_wgs  varchar(100)
  ,sn_rna_seq             varchar(100)
  ,sn_atac_seq            varchar(100)
  ,sc_atac_seq            varchar(100)
  ,sc_rna_seq             varchar(100)
  ,he_codex               varchar(100)
  ,protein_isolation      varchar(100)
  ,rna_isolation          varchar(100)
  ,dna_isolation          varchar(100)
  ,proteomics             varchar(100)
  ,lipidomics             varchar(100)
  ,metabolomics           varchar(100)
  ,dysplasia_category     varchar(100)
  ,dysplasia_percentage   varchar(100)
  ,notes                  varchar(250)
  ,vap_names              varchar(100)
  ,batch_3_he_initial_set varchar(100)
  ,batch_3_assay          varchar(100)
  ,all_assays             varchar(100)
  ,single_nuclei          varchar(100)
)
;
create table staging.sample_coordinates
  (sample_name  varchar(100)
  ,x            integer
  ,y            integer)
;
create table staging.pathology
	(sample                                     varchar(100)
	,normal_tissue                              varchar(100)
	,small_bowel                                varchar(100)
	,colon                                      varchar(100)
	,section_of_bowel                           varchar(100)
	,polyp                                      varchar(100)
	,polyp_type                                 varchar(100)
	,architectural_distortion                   varchar(100)
	,villous_blunting                           varchar(100)
	,surface_and_crypt_epithelial_injury        varchar(100)
	,lamina_propria_inflammation                varchar(100)
	,intra_epithelial_infiltration              varchar(100)
	,lymphocytic_infiltration                   varchar(100)
	,crypts                                     varchar(100)
	,cryptitis                                  varchar(100)
	,pseudomembrane                             varchar(100)
	,percent_of_acellular_mucin_by_area         varchar(100)
	,dysplasia                                  varchar(100)
	,degree_of_dysplasia                        varchar(100)
	,high                                       varchar(100)
	,low                                        varchar(100)
	,percentages                                varchar(100)
	,high_and_low                               varchar(100)
	,percentages_with_respect_to_previous_row   varchar(100)
	,percent_of_neoplastic_cell_nuclei_as_a_total_of_all_cell_nuclei varchar(100)
	,percent_of_non_neoplastic_stroma_by_area   varchar(100)
	,percent_of_entire_tissue_involved_by_tumor varchar(100)
	,percent_normal_overall                     varchar(100)
	,percent_stroma_overall                     varchar(100)
	,percent_cancer_overall                     varchar(100)
	,percent_adenoma_overall                    varchar(100)
	,percent_stroma_in_cancer                   varchar(100)
	,percent_stroma_in_adenoma                  varchar(100)
	,percent_necrosis_in_tumor                  varchar(100)
	,cancer                                     varchar(100)
	,cancer_type                                varchar(100)
	,grade                                      varchar(100)
	,infiltrating_lymphocytes                   varchar(100)
	,crohn_like_response                        varchar(100)
	,necrosis                                   varchar(100)
	,percent_of_tumor_necrosis_by_cellularity   varchar(100)
	,lvsi                                       varchar(100)
	,tumor_budding                              varchar(100)
	,tnm_score                                  varchar(100)
	,stage                                      varchar(100)
	,additional_details_comments                varchar(100))