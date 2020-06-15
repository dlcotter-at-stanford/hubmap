--Using the role/group/user schema suggested in this article on securing Postgres:
--https://severalnines.com/database-blog/how-secure-your-postgresql-database-10-tips
--
--The idea is to create roles with object privileges and users with login privileges,
--then use groups to manage the relationship between users and roles. Using this
--method you can manage the granularity of the privileges and you can easily grant
--and revoke groups of access to the users. In relational terms:
--roles *--* groups *--* users

--role
create role role_readonly nosuperuser inherit nocreatedb nocreaterole noreplication;
grant usage on schema reporting to role_readonly;
grant select on all tables in schema reporting to role_readonly;
alter default privileges in schema reporting grant select on tables to role_readonly;

--group
create role grp_readonly nosuperuser inherit nocreatedb nocreaterole noreplication;
grant role_readonly to grp_readonly;

--user
create role hubmap with login;
--alter role hubmap with password 'somepassword';  # set the password manually since this file will be included in the Git repo
alter role hubmap valid until 'infinity';
grant grp_readonly to hubmap;
