#!/bin/sh

SQL_DIR=../sql/
#/Users/dlcott2/Documents/work/HuBMAP/dev/data-portal/db
psql -h localhost -d postgres -U postgres -f /Users/dlcott2/Documents/work/HuBMAP/dev/data-portal/db/sql/database/database.sql
psql -h localhost -d hubmap   -U postgres -f /Users/dlcott2/Documents/work/HuBMAP/dev/data-portal/db/sql/database/schemas/schemas.sql
psql -h localhost -d hubmap   -U postgres -f /Users/dlcott2/Documents/work/HuBMAP/dev/data-portal/db/sql/database/staging.ddl.sql
psql -h localhost -d hubmap   -U postgres -f /Users/dlcott2/Documents/work/HuBMAP/dev/data-portal/db/sql/database/staging.etl.sql
psql -h localhost -d hubmap   -U postgres -f /Users/dlcott2/Documents/work/HuBMAP/dev/data-portal/db/sql/database/reporting.ddl.sql
psql -h localhost -d hubmap   -U postgres -f /Users/dlcott2/Documents/work/HuBMAP/dev/data-portal/db/sql/database/reporting.etl.sql
psql -h localhost -d hubmap   -U postgres -f /Users/dlcott2/Documents/work/HuBMAP/dev/data-portal/db/sql/database/get_pathology.proc.sql
psql -h localhost -d hubmap   -U postgres -f /Users/dlcott2/Documents/work/HuBMAP/dev/data-portal/db/sql/database/get_samples.proc.sql
psql -h localhost -d hubmap   -U postgres -f /Users/dlcott2/Documents/work/HuBMAP/dev/data-portal/db/sql/database/get_subjects.proc.sql
psql -h localhost -d hubmap   -U postgres -f /Users/dlcott2/Documents/work/HuBMAP/dev/data-portal/db/sql/database/role.sql
