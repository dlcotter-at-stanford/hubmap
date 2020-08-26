--Author: Daniel Cotter
--Date: 5/26/2020
--Status: working properly
--Purpose: Get pathology data for a given subject

create or replace function core.get_pathology(p_subject_bk character varying)
 returns table(
   sample_bk character varying
  ,normal_tissue bool
  ,polyp_type character varying
  ,architectural_distortion bool 
  ,villous_blunting bool 
  ,surface_and_crypt_epithelial_injury bool 
  ,lamina_propria_inflammation bool 
  ,intra_epithelial_infiltration bool 
  ,lymphocytic_infiltration bool 
  ,crypts bool 
  ,cryptitis bool 
  ,pseudomembrane bool 
  ,percent_of_acellular_mucin_by_area numeric(3,2) 
  ,dysplasia bool 
  ,degree_of_dysplasia character varying
  ,high bool 
  ,high_pct numeric(3,2) 
  ,low bool 
  ,low_pct numeric(3,2) 
  ,pct_neoplastic_nuclei_tumor_only numeric(3,2) 
  ,pct_non_neoplastic_stroma_by_area numeric(3,2) 
  ,pct_entire_tissue_involved_by_tumor numeric(3,2) 
  ,pct_normal_overall numeric(3,2) 
  ,pct_stroma_overall numeric(3,2) 
  ,pct_cancer_overall numeric(3,2) 
  ,pct_adenoma_overall numeric(3,2) 
  ,pct_stroma_in_cancer numeric(3,2) 
  ,pct_stroma_in_adenoma numeric(3,2) 
  ,pct_necrosis_in_tumor numeric(3,2) 
  ,cancer bool 
  ,cancer_type character varying
  ,grade int2 
  ,infiltrating_lymphocytes bool 
  ,crohn_like_response bool 
  ,necrosis bool 
  ,pct_tumor_necrosis_by_cellularity numeric(3,2) 
  ,lvsi bool 
  ,tumor_budding character varying
  ,tnm_score character varying
  ,stage character varying
  ,additional_details_comments character varying)
 language sql
as $function$
select
	 sample.sample_bk
	,pathology.normal_tissue
	,pathology.polyp_type
	,pathology.architectural_distortion
	,pathology.villous_blunting
	,pathology.surface_and_crypt_epithelial_injury
	,pathology.lamina_propria_inflammation
	,pathology.intra_epithelial_infiltration
	,pathology.lymphocytic_infiltration
	,pathology.crypts
	,pathology.cryptitis
	,pathology.pseudomembrane
	,pathology.percent_of_acellular_mucin_by_area
	,pathology.dysplasia
	,pathology.degree_of_dysplasia
	,pathology.high
	,pathology.high_pct
	,pathology.low
	,pathology.low_pct
	,pathology.pct_neoplastic_nuclei_tumor_only
	,pathology.pct_non_neoplastic_stroma_by_area
	,pathology.pct_entire_tissue_involved_by_tumor
	,pathology.pct_normal_overall
	,pathology.pct_stroma_overall
	,pathology.pct_cancer_overall
	,pathology.pct_adenoma_overall
	,pathology.pct_stroma_in_cancer
	,pathology.pct_stroma_in_adenoma
	,pathology.pct_necrosis_in_tumor
	,pathology.cancer
	,pathology.cancer_type
	,pathology.grade
	,pathology.infiltrating_lymphocytes
	,pathology.crohn_like_response
	,pathology.necrosis
	,pathology.pct_tumor_necrosis_by_cellularity
	,pathology.lvsi
	,pathology.tumor_budding
	,pathology.tnm_score
	,pathology.stage
	,pathology.additional_details_comments
from core.subject
join core.sample on sample.subject_pk = subject.subject_pk
join core.pathology on pathology.sample_pk = sample.sample_pk
where lower(subject.subject_bk) = lower(p_subject_bk)
order by sample.sample_bk
$function$
;
