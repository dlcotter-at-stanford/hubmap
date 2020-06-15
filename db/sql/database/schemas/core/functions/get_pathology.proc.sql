--Author: Daniel Cotter
--Date: 5/26/2020
--Status: working properly
--Purpose: Get pathology data for a given subject, unpivot the long list of columns into key-value pairs

drop function if exists get_pathology(character varying)
;
create or replace
function reporting.get_pathology
	(p_subject_bk varchar(100))
returns table
	(sample_bk	varchar(100)
	,attr		varchar(100)
	,value		varchar(100))
language sql
as
$$
--Purpose  : Return the pathology information by subject as key-value pairs,
--           excluding columns with null values (which is most columns for
--           most samples, but not in a predictable pattern).
--Structure: Three inner joins, from subject to sample to pathology report,
--           and then to an unpivoted version of the pathology report, followed
--           by a *where* clause that drops the null-valued pathology attributes.
select sample.sample_bk, replace(p.k,'_',' '), p.v
from reporting.subject
join reporting.sample on sample.subject_pk = subject.subject_pk
join reporting.pathology on pathology.sample_pk = sample.sample_pk
join lateral(values
	('normal_tissue',pathology.normal_tissue::varchar(100)),
	('polyp_type',pathology.polyp_type),
	('architectural_distortion',pathology.architectural_distortion::varchar(100)),
	('villous_blunting',pathology.villous_blunting::varchar(100)),
	('surface_and_crypt_epithelial_injury',pathology.surface_and_crypt_epithelial_injury::varchar(100)),
	('lamina_propria_inflammation',pathology.lamina_propria_inflammation::varchar(100)),
	('intra_epithelial_infiltration',pathology.intra_epithelial_infiltration::varchar(100)),
	('lymphocytic_infiltration',pathology.lymphocytic_infiltration::varchar(100)),
	('crypts',pathology.crypts::varchar(100)),
	('cryptitis',pathology.cryptitis::varchar(100)),
	('pseudomembrane',pathology.pseudomembrane::varchar(100)),
	('percent_of_acellular_mucin_by_area',pathology.percent_of_acellular_mucin_by_area::varchar(100)),
	('dysplasia',pathology.dysplasia::varchar(100)),
	('degree_of_dysplasia',pathology.degree_of_dysplasia),
	('high',pathology.high::varchar(100)),
	('high_pct',pathology.high_pct::varchar(100)),
	('low',pathology.low::varchar(100)),
	('low_pct',pathology.low_pct::varchar(100)),
	('pct_neoplastic_nuclei_tumor_only',pathology.pct_neoplastic_nuclei_tumor_only::varchar(100)),
	('pct_non_neoplastic_stroma_by_area',pathology.pct_non_neoplastic_stroma_by_area::varchar(100)),
	('pct_entire_tissue_involved_by_tumor',pathology.pct_entire_tissue_involved_by_tumor::varchar(100)),
	('pct_normal_overall',pathology.pct_normal_overall::varchar(100)),
	('pct_stroma_overall',pathology.pct_stroma_overall::varchar(100)),
	('pct_cancer_overall',pathology.pct_cancer_overall::varchar(100)),
	('pct_adenoma_overall',pathology.pct_adenoma_overall::varchar(100)),
	('pct_stroma_in_cancer',pathology.pct_stroma_in_cancer::varchar(100)),
	('pct_stroma_in_adenoma',pathology.pct_stroma_in_adenoma::varchar(100)),
	('pct_necrosis_in_tumor',pathology.pct_necrosis_in_tumor::varchar(100)),
	('cancer',pathology.cancer::varchar(100)),
	('cancer_type',pathology.cancer_type),
	('grade',pathology.grade::varchar(100)),
	('infiltrating_lymphocytes',pathology.infiltrating_lymphocytes::varchar(100)),
	('crohn_like_response',pathology.crohn_like_response::varchar(100)),
	('necrosis',pathology.necrosis::varchar(100)),
	('pct_tumor_necrosis_by_cellularity',pathology.pct_tumor_necrosis_by_cellularity::varchar(100)),
	('lvsi',pathology.lvsi::varchar(100)),
	('tumor_budding',pathology.tumor_budding),
	('tnm_score',pathology.tnm_score),
	('stage',pathology.stage),
	('additional_details_comments',pathology.additional_details_comments)) p(k,v)
on p.v is not null
where subject.subject_bk = p_subject_bk
$$
;
