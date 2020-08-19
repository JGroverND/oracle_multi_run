-- ---------------------------------------------------------------------
-- File: check_dba_roles.sql
-- Desc:
--
-- Audit Trail:
-- 17-aug-2020  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set pagesize 0
set linesize 300
set trimout on
set heading off
set feedback off
set serveroutput on
set markup csv on
--
--
--
column  name            format a10
column  database        format a10
column  username        format a30
column  grantee         format a30
column  role            format a30
column  granted_role    format a30
column  profile         format a30
column  privilege       format a22
column  param           format a30
column  value           format a30

--
--
--
  select name, username, granted_role, profile
    from dba_users
    join v$database on 1=1
    join dba_role_privs on grantee = username
   where granted_role in ('DBA', 'ND_DBA_S_ROLE')
   order by granted_role, profile, username
/
--
--
--
exit;
