create table core.pathology
  (pathology_pk                serial primary key
  ,sample_pk                  integer references core.sample(sample_pk)
  ,normal_tissue                              boolean
  --,small_bowel      - redundant with sample table field "organ"
  --,colon            - redundant with sample table field "organ"
  --,section_of_bowel - redundant with sample table field "organ_piece"
  --,polyp            - redundant with sample table field "stage"
  ,polyp_type                                 varchar(100)
  ,architectural_distortion                   boolean
  ,villous_blunting                           boolean
  ,surface_and_crypt_epithelial_injury        boolean
  ,lamina_propria_inflammation                boolean
  ,intra_epithelial_infiltration              boolean
  ,lymphocytic_infiltration                   boolean
  ,crypts                                     boolean
  ,cryptitis                                  boolean
  ,pseudomembrane                             boolean
  ,percent_of_acellular_mucin_by_area         decimal(3,2)
  ,dysplasia                                  boolean
  ,degree_of_dysplasia                        varchar(100)
  ,high                                       boolean
  ,high_pct                                   decimal(3,2)
  ,low                                        boolean
  ,low_pct                                    decimal(3,2)
  --,percentages  - redundant with previous low/high/pct columns
  --,high_and_low - redundant with previous low/high/pct columns
  --,percentages_with_respect_to_previous_row - redundant with previous low/high/pct columns
  ,pct_neoplastic_nuclei_tumor_only           decimal(3,2)
  ,pct_non_neoplastic_stroma_by_area          decimal(3,2)
  ,pct_entire_tissue_involved_by_tumor        decimal(3,2)
  ,pct_normal_overall                         decimal(3,2)
  ,pct_stroma_overall                         decimal(3,2)
  ,pct_cancer_overall                         decimal(3,2)
  ,pct_adenoma_overall                        decimal(3,2)
  ,pct_stroma_in_cancer                       decimal(3,2)
  ,pct_stroma_in_adenoma                      decimal(3,2)
  ,pct_necrosis_in_tumor                      decimal(3,2)
  ,cancer                                     boolean
  ,cancer_type                                varchar(100)
  ,grade                                      smallint
  ,infiltrating_lymphocytes                   boolean
  ,crohn_like_response                        boolean
  ,necrosis                                   boolean
  ,pct_tumor_necrosis_by_cellularity          decimal(3,2)
  ,lvsi                                       boolean
  ,tumor_budding                              varchar(100)
  ,tnm_score                                  varchar(100)
  ,stage                                      varchar(100)
  ,additional_details_comments                varchar(100))
;
