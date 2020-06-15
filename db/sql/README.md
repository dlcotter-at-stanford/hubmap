This directory sub-tree is organized according to object type, which is the
scheme used by Postgres. I had originally organized it according to SQL language
subtype (DDL) or functionality (ETL) but I think this way is better because
it matches clearly to what you see when you look at the database in a SQL client.

.
└── database
    ├── extensions
    ├── roles
    └── schemas
        ├── assay
        ├── core
        │   └── functions
        ├── metadata
        └── staging

