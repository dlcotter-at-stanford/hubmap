--Aaron's email:
--I'm looking over the samples of DNA that we have and trying to choose some samples which accommodate for a couple different factors:
--The samples should represent different stages of the polyp formation
--The samples should have been previously analyzed by a different -omic technology.
--I should have enough sample too give you ~500 ng (and I need ~1ug for a different assay we are interested in running as well (Graham, please confirm this is the case). Therefore, these “abundant” samples should have at least 1.5 ug of DNA.
--I haven’t forgotten about this but if these are all the assumptions I need to work with, this may change the samples that we’ll analyze. 
--Zohar, would I be limited to only 5 samples? Can we provide you with 10 (5 “abundant” and 5 “not-abundant”)? Im asking because we have some previously sequenced samples that we’d like to have additional sequencing done on but I dont have enough DNA (hence the moniker “not-abundant”).

--Extracted requirements:
--DNA samples
--representing different stages of polyp formation
--previously analyzed by a different -omic technology
--at least 1.5ug of DNA
 
with
	omics as
		(select sample_bk
			,amount
			,unit
			,collection
			,organ
			,organ_piece
			,stage
			,phenotype
			,size_width
			,size_length
			,size_depth
			,dysplasia_cat
			,dysplasia_pct
			,notes
			,(case
				when atacseq_bulk or atacseq_sn or
					rnaseq_bulk or rnaseq_sn or rnaseq_sc or
					isolation_dna or isolation_rna or
					single_gland_atac_wgs or wes or wgs or wg_bisulfite
				then true
			end) as genomics
			,lipidomics
			,metabolomics
			,proteomics
			--isolation_protein?
		from core.sample
		--join core.tissue on tissue.sample_pk = sample.sample_pk
		--join core.assay on assay.tissue_pk = tissue.tissue_pk
		where sample.amount > (1.5/1000) and sample.unit = 'mg')
select *
from omics
where genomics or lipidomics or metabolomics or proteomics

		
