create table core.sample
  (sample_pk             serial primary key
  ,subject_pk            integer not null references core.subject(subject_pk)
  ,sample_bk             varchar(100) not null unique
  ,amount                decimal(10,2)
  ,unit                  varchar(100)
  ,collection            varchar(100)
  ,organ                 varchar(100)
  ,organ_piece           varchar(100)
  ,stage                 varchar(100)
  ,phenotype             varchar(100)
  ,size_length           numeric(4,1)
  ,size_width            numeric(4,1)
  ,size_depth            numeric(4,1)
  ,x_coord               numeric(5,1)
  ,y_coord               numeric(5,1)
  ,dysplasia_cat         varchar(100)
  ,dysplasia_pct         integer
  ,notes                 varchar(200)
  ,vap_names             varchar(100)
  ,atacseq_bulk          boolean
  ,atacseq_sn            boolean
  ,atacseq_sc            boolean
  ,codex                 boolean
  ,lipidomics            boolean
  ,metabolomics          boolean
  ,proteomics            boolean
  ,rnaseq_bulk           boolean
  ,rnaseq_sn             boolean
  ,rnaseq_sc             boolean
  ,isolation_dna         boolean
  ,isolation_rna         boolean
  ,isolation_protein     boolean
  ,single_gland_atac_wgs boolean
  ,wes                   boolean
  ,wgs                   boolean
  ,wg_bisulfite          boolean)
;
