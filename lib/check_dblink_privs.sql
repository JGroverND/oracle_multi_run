-- ---------------------------------------------------------------------
-- File: sql/check_dblink_privs.sql
-- Desc:
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
--  - Original Code
--
-- create role nd_ods_ir_team_s_role ;
-- grant create database link to nd_ods_ir_team_s_role ;
-- grant nd_ods_ir_team_s_role to KCRANE, BRYPMA, CBELMARE, CKUBITSC, SOLSON ;
--
-- ---------------------------------------------------------------------
set pagesize 0
set linesize 300
set trimout on
set heading off
set feedback off

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
column  privilege       format a30
column  param           format a30
column  value           format a30

--
--
--
select d.name, u.username, u.profile, d.privilege
  from v$database d, dba_sys_privs d, dba_users u
 where u.username = d.grantee
   and privilege like '%DATABASE LINK%'
--   and u.profile not like 'ND_SYS%'
--   and u.profile != 'ND_USR_OPEN_DBA'
union
select d.name, r.role, 'Role', d.privilege
  from v$database d, dba_sys_privs d, dba_roles r
 where r.role = d.grantee
   and privilege like '%DATABASE LINK%'
   and r.role not in ('DBA', 'RESOURCE', 'IMP_FULL_DATABASE', 'RECOVERY_CATALOG_OWNER', 'ND_ODS_IR_TEAM_S_ROLE')
 /
 
 exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

