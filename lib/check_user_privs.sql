-- ---------------------------------------------------------------------
-- File: sql/check_user_privs.sql
-- Desc:
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set pagesize 0
set linesize 300
set trimout on
set heading off
set feedback off
set verify off

--
--
--
column  name            format a10
column  type            format a10
column  database        format a10
column  username        format a30
column  grantee         format a30
column  grantor         format a30
column  owner           format a30
column  role            format a30
column  granted_role    format a30
column  profile         format a30
column  privilege       format a22
column  param           format a30
column  value           format a30

--
--
--
-- -------------------------------------
-- USER: Privilege summary (non-Banner)
-- -------------------------------------
select 'Database, Priv Type, Grantee, Object, Privilege/Role, Grantable, Grantor, Default'
  from v$database, dual
UNION
select name || ', ' ||
       'Role' || ', ' ||
       GRANTEE || ', ' ||
       '?'  || ', ' ||
       GRANTED_ROLE || decode(DEFAULT_ROLE, 'YES', '*', null) || ', ' ||
       '?' || ', ' ||
       ADMIN_OPTION || ', ' ||
       '?'
  from v$database d, dba_role_privs
 where grantee = upper('&&1')
union
-- -------------------------------------
select ' Database: ' || name  ||
       ' Account: '  || username ||
       ' Profile: '  || profile || 
       ' Account Status: ' || account_status
  from v$database d, dba_users
 where username = upper('&&1')
union
-- -------------------------------------
select name  || ', ' ||
       'Ownership'  || ', ' ||
       owner || ', ' ||
       object_type  || ', ' ||
       to_char(count(*))  || ', ' ||
       '?' || ', ' ||
       '?' || ', ' ||
       '?'
  from v$database d, dba_objects
 where owner = upper('&&1')
  group by name, owner, object_type
union
-- -------------------------------------
select name  || ', ' ||
       'System'  || ', ' ||
       GRANTEE  || ', ' ||
       '?' || ', ' ||
       PRIVILEGE  || ', ' ||
       ADMIN_OPTION  || ', ' ||
       '?' || ', ' ||
       '?' 
  from v$database d, dba_sys_privs
 where grantee = upper('&&1')
union
-- -------------------------------------
select name  || ', ' ||
       'Table'  || ', ' ||
       GRANTEE  || ', ' ||
       OWNER  || '.' || TABLE_NAME  || ', ' ||
       PRIVILEGE  || ', ' ||
       GRANTABLE  || ', ' ||
       GRANTOR  || ', ' ||
       '?' 
  from v$database d, dba_tab_privs
 where grantee = upper('&&1')
union
-- -------------------------------------
select name   || ', ' ||
       'Col Priv'  || ', ' ||
       GRANTEE  || ', ' ||
       OWNER  || '.' ||
       TABLE_NAME||'.'||COLUMN_NAME  || ', ' ||
       PRIVILEGE  || ', ' ||
       GRANTABLE  || ', ' ||
       GRANTOR  || ', ' ||
       '?'
  from v$database d, dba_col_privs
 where grantee = upper('&&1')
/
 
 exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

