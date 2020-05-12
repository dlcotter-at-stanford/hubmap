--> connect to hubmap database
drop schema if exists reporting cascade
;
create schema reporting
;
-- By convention the primary key for each entity table will be suffixed with "_pk" and
-- the business key will be suffixed with "_id". The data type for primary keys will
-- be integer (for efficiency) and for business keys will be character (to match
-- alphanumeric naming convention of study).
create table reporting.subject
  (subject_pk     serial primary key
  ,subject_bk     varchar(100)
  ,disease_status varchar(100))
;
create table reporting.sample
  (sample_pk      serial primary key
  ,subject_pk     integer references reporting.subject(subject_pk)
  ,sample_bk      varchar(100)
  ,amount         decimal(10,2)
  ,unit           varchar(100)
  ,collection     varchar(100)
  ,organ          varchar(100)
  ,organ_piece    varchar(100)
  ,stage          varchar(100)
  ,phenotype      varchar(100)
  ,size_length    numeric(4,1)
  ,size_width     numeric(4,1)
  ,size_depth     numeric(4,1)
  ,x_coord        integer
  ,y_coord        integer
  ,dysplasia_cat  varchar(100)
  ,dysplasia_pct  integer
  ,notes          varchar(200)
  ,vap_names      varchar(100))
;
create table reporting.tissue
  (tissue_pk      serial primary key
  ,sample_pk      integer references reporting.sample(sample_pk)
  ,tissue_bk      varchar(100)
  ,init_pres_mthd varchar(100)
  ,curr_pres_mthd varchar(100))
;
create table reporting."storage"
  (storage_pk serial primary key
  ,tissue_pk  integer references reporting.tissue(tissue_pk)
  ,building   varchar(100)
  ,freezer    varchar(100)
  ,rack       varchar(100)
  ,box_name   varchar(100))
;
create table reporting.assay
  (assay_pk   serial primary key
  ,tissue_pk  integer references reporting.tissue(tissue_pk)
  ,assay_type varchar(100)
  ,perf_date  date
  ,researcher varchar(100)
  ,equipment  varchar(100)
  ,seq_depth  varchar(100))
;
create table reporting.pathology
	(pathology_pk								serial primary key
	,sample_pk									integer references reporting.sample(sample_pk)
	,normal_tissue                              boolean
	--,small_bowel                                boolean  --redundant with sample table (field "organ")
	--,colon                                      boolean  --redundant with sample table (field "organ")
	--,section_of_bowel                           varchar(100)  --redundant with sample table (field "organ_piece")
	--,polyp                                      boolean  --redundant with sample table (field "stage")
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
	,high_pct									decimal(3,2)
	,low                                        boolean
	,low_pct									decimal(3,2)
	--,percentages                                varchar(100)  --redundant with previous low/high/pct columns
	--,high_and_low                               varchar(100)  --redundant with previous low/high/pct columns
	--,percentages_with_respect_to_previous_row   varchar(100)  --redundant with previous low/high/pct columns
	,pct_neoplastic_nuclei_tumor_only			decimal(3,2)
	,pct_non_neoplastic_stroma_by_area			decimal(3,2)
	,pct_entire_tissue_involved_by_tumor		decimal(3,2)
	,pct_normal_overall							decimal(3,2)
	,pct_stroma_overall							decimal(3,2)
	,pct_cancer_overall							decimal(3,2)
	,pct_adenoma_overall						decimal(3,2)
	,pct_stroma_in_cancer						decimal(3,2)
	,pct_stroma_in_adenoma						decimal(3,2)
	,pct_necrosis_in_tumor						decimal(3,2)
	,cancer                                     boolean
	,cancer_type                                varchar(100)
	,grade                                      smallint
	,infiltrating_lymphocytes                   boolean
	,crohn_like_response                        boolean
	,necrosis                                   boolean
	,pct_tumor_necrosis_by_cellularity   		decimal(3,2)
	,lvsi                                       boolean
	,tumor_budding                              varchar(100)
	,tnm_score                                  varchar(100)
	,stage                                      varchar(100)
	,additional_details_comments                varchar(100))
