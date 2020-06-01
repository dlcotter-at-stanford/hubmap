#!/bin/sh

psql -h localhost -d postgres -U postgres -f database.sql
psql -h localhost -d hubmap   -U postgres -f schema.sql
psql -h localhost -d hubmap   -U postgres -f staging.ddl.sql
psql -h localhost -d hubmap   -U postgres -f staging.etl.sql
psql -h localhost -d hubmap   -U postgres -f reporting.ddl.sql
psql -h localhost -d hubmap   -U postgres -f reporting.etl.sql
psql -h localhost -d hubmap   -U postgres -f get_pathology.proc.sql
psql -h localhost -d hubmap   -U postgres -f get_samples.proc.sql
psql -h localhost -d hubmap   -U postgres -f get_subjects.proc.sql
