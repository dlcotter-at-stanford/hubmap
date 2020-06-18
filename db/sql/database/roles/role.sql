--Using the role/group/user schema suggested in this article on securing Postgres:
--https://severalnines.com/database-blog/how-secure-your-postgresql-database-10-tips
--
--The idea is to create roles with object privileges and users with login privileges,
--then use groups to manage the relationship between users and roles. Using this
--method you can manage the granularity of the privileges and you can easily grant
--and revoke groups of access to the users. In relational terms:
--roles *--* groups *--* users

--Note that Postgres roles are created across an entire database cluster,
--according to the docs (https://www.postgresql.org/docs/current/sql-createrole.html,
--"CREATE ROLE adds a new role to a PostgreSQL database cluster"), and there
--does not seem to be an easy way around this, i.e. to create a single-database
--role. This doesn't matter much in practice, since this database and application
--are intended to be deployed on a standalone database server with no other
--applications on it, but if that changes and weird stuff starts happening with
--respect to roles and permissions, this code might be the culprit.

--role
drop role if exists role_readonly;
create role role_readonly nosuperuser inherit nocreatedb nocreaterole noreplication;
grant usage on schema core, metadata, staging to role_readonly;
grant select on all tables in schema core, metadata, staging to role_readonly;
alter default privileges in schema core, metadata, staging grant select on tables to role_readonly;

--group
drop role if exists grp_readonly;
create role grp_readonly nosuperuser inherit nocreatedb nocreaterole noreplication;
grant role_readonly to grp_readonly;

--user
drop role if exists hubmap;
create role hubmap with login;
--alter role hubmap with password 'somepassword';  # set the password manually since this file will be included in the Git repo
alter role hubmap valid until 'infinity';
grant grp_readonly to hubmap;
