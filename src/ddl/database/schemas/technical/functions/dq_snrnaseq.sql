
--data quality check
select
	 md.sample
	,sample.sample_bk
	,md.tissue_location
	,sample.organ_piece
	,md.tissue_phenotype
	,sample.phenotype
	,case
		when sample.sample_bk is null 
		then 'Sample not found in database'
		when lower(md.tissue_location) <> lower(sample.organ_piece)
		then 'Mismatch between sample locations (i.e. organ piece)'
		when trim(lower(md.tissue_phenotype)) <> trim(lower(sample.phenotype))
		then 'Mismatch between sample phenotypes'
	end as reason
from staging.metadata_rnaseq_single_nucleus_addl md
left join core.sample on sample.sample_bk = md.sample
where sample.sample_bk is null
or trim(lower(md.tissue_location)) <> trim(lower(sample.organ_piece))
or trim(lower(md.tissue_phenotype)) <> trim(lower(sample.phenotype))
;

--should match what's in tissue table
   tissue_preservation_method --tissue
