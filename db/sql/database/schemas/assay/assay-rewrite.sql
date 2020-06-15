drop table if exists assay
;
create temp table assay(tissue_bk, name_, attr, val) as
select tissue.tissue_bk, l.k as assay, l2.k as attr, l2.v as val
from staging.sample_tracker
join reporting.tissue on tissue.tissue_bk = sample_tracker.tissue_number
join lateral(values
	 ('DNA Whole Genome Sequencing', sample_tracker.dna_wgs)
	,('DNA Whole Exome Sequencing', sample_tracker.dna_wes)
	,('Whole Genome Bisulfite', sample_tracker.wg_bisulfite)
	,('RNA Sequencing', sample_tracker.rna_seq)
	,('Bulk ATAC', sample_tracker.bulk_atac)
	,('Single-Gland ATAC Whole Genome Sequencing', sample_tracker.single_gland_atac_wgs)
	,('Single-Nucleus RNA Sequencing', sample_tracker.sn_rna_seq)
	,('Single-Nucleus ATAC Sequencing', sample_tracker.sn_atac_seq)
	,('Single-Cell ATACseq', sample_tracker.sc_atac_seq)
	,('Single-Cell RNAseq', sample_tracker.sc_rna_seq)
	,('HE/CODEX', sample_tracker.he_codex)
	,('Protein Isolation', sample_tracker.protein_isolation)
	,('RNA Isolation', sample_tracker.rna_isolation)
	,('DNA Isolation', sample_tracker.dna_isolation)
	,('Proteomics', sample_tracker.proteomics)
	,('Lipidomics', sample_tracker.lipidomics)
	,('Metabolomics', sample_tracker.metabolomics)
) l(k,v) on l.v is not null
join lateral(values
	 ('perf_date' , substring(lower(l.v), '(([1-9]|1[0-2])\/([1-9]|[1-2][0-9]|3[0-1])\/(1[5-9]|2[0-5]))'))
    ,('researcher', substring(lower(l.v), 'tuhin|lihua|kevin|mark'))
    ,('equipment' , substring(lower(l.v), 'novogene|personalis|bulk omniatac'))
    ,('seq_depth' , substring(lower(l.v), '\d{2,3}x'))
) l2(k,v) on l2.v is not null
;

select ct.*
from crosstab(
	'select tissue_bk::text, attr, val
	from assay
	where tissue_bk = ''A001-C-002-1''
	and name_ = ''RNA Isolation''
	order by 1,2')
	as ct
	(tissue_bk  text
	,perf_date  text
	,researcher text
	,equipment  text
	,seq_depth  text)
;
select tissue_bk, attr, val
from assay
where tissue_bk = 'A001-C-002-1'
and name_ = 'RNA Isolation'
order by 1,2
;

select * from assay where tissue_bk = 'A001-C-002-1'
--create extension if not exists tablefunc --installs tablefunc module containing 'crosstab()'