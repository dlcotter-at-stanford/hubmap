create or replace
function core.insert_sample
         (p_study_bk              varchar(100)
         ,p_subject_bk            varchar(100)
         ,p_sample_bk             varchar(100)
         ,p_amount                numeric(10,2)
         ,p_unit                  varchar(100)
         ,p_collection            varchar(100)
         ,p_organ                 varchar(100)
         ,p_organ_piece           varchar(100)
         ,p_stage                 varchar(100)
         ,p_phenotype             varchar(100)
         ,p_size_length           numeric(4,1)
         ,p_size_width            numeric(4,1)
         ,p_size_depth            numeric(4,1)
         ,p_x_coord               numeric(5,1)
         ,p_y_coord               numeric(5,1)
         ,p_dysplasia_cat         varchar(100)
         ,p_dysplasia_pct         integer
         ,p_notes                 varchar(200)
         ,p_vap_names             varchar(100)
         ,p_atacseq_bulk          boolean
         ,p_atacseq_sn            boolean
         ,p_atacseq_sc            boolean
         ,p_codex                 boolean
         ,p_lipidomics            boolean
         ,p_metabolomics          boolean
         ,p_proteomics            boolean
         ,p_rnaseq_bulk           boolean
         ,p_rnaseq_sn             boolean
         ,p_rnaseq_sc             boolean
         ,p_isolation_dna         boolean
         ,p_isolation_rna         boolean
         ,p_isolation_protein     boolean
         ,p_single_gland_atac_wgs boolean
         ,p_wes                   boolean
         ,p_wgs                   boolean
         ,p_wg_bisulfite          boolean)
returns table 
         (sample_pk               integer       --used to demonstrated idempotence in REST API
         ,sample_bk               varchar(100)
         ,amount                  numeric(10,2)
         ,unit                    varchar(100)
         ,collection              varchar(100)
         ,organ                   varchar(100)
         ,organ_piece             varchar(100)
         ,stage                   varchar(100)
         ,phenotype               varchar(100)
         ,size_length             numeric(4,1)
         ,size_width              numeric(4,1)
         ,size_depth              numeric(4,1)
         ,x_coord                 numeric(5,1)
         ,y_coord                 numeric(5,1)
         ,dysplasia_cat           varchar(100)
         ,dysplasia_pct           integer
         ,notes                   varchar(200)
         ,vap_names               varchar(100)
         ,atacseq_bulk            boolean
         ,atacseq_sn              boolean
         ,atacseq_sc              boolean
         ,codex                   boolean
         ,lipidomics              boolean
         ,metabolomics            boolean
         ,proteomics              boolean
         ,rnaseq_bulk             boolean
         ,rnaseq_sn               boolean
         ,rnaseq_sc               boolean
         ,isolation_dna           boolean
         ,isolation_rna           boolean
         ,isolation_protein       boolean
         ,single_gland_atac_wgs   boolean
         ,wes                     boolean
         ,wgs                     boolean
         ,wg_bisulfite            boolean)
language sql
as
$$
insert into  core.sample
             (subject_pk
             ,sample_bk
             ,amount
             ,unit
             ,collection
             ,organ
             ,organ_piece
             ,stage
             ,phenotype
             ,size_length
             ,size_width
             ,size_depth
             ,x_coord
             ,y_coord
             ,dysplasia_cat
             ,dysplasia_pct
             ,notes
             ,vap_names
             ,atacseq_bulk
             ,atacseq_sn
             ,atacseq_sc
             ,codex
             ,lipidomics
             ,metabolomics
             ,proteomics
             ,rnaseq_bulk
             ,rnaseq_sn
             ,rnaseq_sc
             ,isolation_dna
             ,isolation_rna
             ,isolation_protein
             ,single_gland_atac_wgs
             ,wes
             ,wgs
             ,wg_bisulfite)
select        subject.subject_pk
             ,p_sample_bk
             ,p_amount
             ,p_unit
             ,p_collection
             ,p_organ
             ,p_organ_piece
             ,p_stage
             ,p_phenotype
             ,p_size_length
             ,p_size_width
             ,p_size_depth
             ,p_x_coord
             ,p_y_coord
             ,p_dysplasia_cat
             ,p_dysplasia_pct
             ,p_notes
             ,p_vap_names
             ,p_atacseq_bulk
             ,p_atacseq_sn
             ,p_atacseq_sc
             ,p_codex
             ,p_lipidomics
             ,p_metabolomics
             ,p_proteomics
             ,p_rnaseq_bulk
             ,p_rnaseq_sn
             ,p_rnaseq_sc
             ,p_isolation_dna
             ,p_isolation_rna
             ,p_isolation_protein
             ,p_single_gland_atac_wgs
             ,p_wes
             ,p_wgs
             ,p_wg_bisulfite
from         core.subject
join         core.study on study.study_pk = subject.study_pk
where        subject.subject_bk = p_subject_bk
and          study.study_bk = p_study_bk
on conflict  (sample_bk) do
update set   amount = p_amount
            ,unit = p_unit
            ,collection = p_collection
            ,organ = p_organ
            ,organ_piece = p_organ_piece
            ,stage = p_stage
            ,phenotype = p_phenotype
            ,size_length = p_size_length
            ,size_width = p_size_width
            ,size_depth = p_size_depth
            ,x_coord = p_x_coord
            ,y_coord = p_y_coord
            ,dysplasia_cat = p_dysplasia_cat
            ,dysplasia_pct = p_dysplasia_pct
            ,notes = p_notes
            ,vap_names = p_vap_names
            ,atacseq_bulk = p_atacseq_bulk
            ,atacseq_sn = p_atacseq_sn
            ,atacseq_sc = p_atacseq_sc
            ,codex = p_codex
            ,lipidomics = p_lipidomics
            ,metabolomics = p_metabolomics
            ,proteomics = p_proteomics
            ,rnaseq_bulk = p_rnaseq_bulk
            ,rnaseq_sn = p_rnaseq_sn
            ,rnaseq_sc = p_rnaseq_sc
            ,isolation_dna = p_isolation_dna
            ,isolation_rna = p_isolation_rna
            ,isolation_protein = p_isolation_protein
            ,single_gland_atac_wgs = p_single_gland_atac_wgs
            ,wes = p_wes
            ,wgs = p_wgs
            ,wg_bisulfite = p_wg_bisulfite
returning    sample_pk
            ,sample_bk
            ,amount
            ,unit
            ,collection
            ,organ
            ,organ_piece
            ,stage
            ,phenotype
            ,size_length
            ,size_width
            ,size_depth
            ,x_coord
            ,y_coord
            ,dysplasia_cat
            ,dysplasia_pct
            ,notes
            ,vap_names
            ,atacseq_bulk
            ,atacseq_sn
            ,atacseq_sc
            ,codex
            ,lipidomics
            ,metabolomics
            ,proteomics
            ,rnaseq_bulk
            ,rnaseq_sn
            ,rnaseq_sc
            ,isolation_dna
            ,isolation_rna
            ,isolation_protein
            ,single_gland_atac_wgs
            ,wes
            ,wgs
            ,wg_bisulfite
$$

