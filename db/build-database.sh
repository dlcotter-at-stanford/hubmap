#!/bin/zsh

psql -d hubmap -f staging.ddl.sql
psql -d hubmap -f staging.etl.sql
psql -d hubmap -f reporting.ddl.sql
psql -d hubmap -f reporting.etl.sql
psql -d hubmap -f roles.sql

