-- ---------------------------------------------------------------------
-- File: sql/check_pubsyn_privs.sql
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
select d.name, u.username, u.profile, s.privilege
  from v$database d, dba_users u, dba_sys_privs s
 where ( privilege = 'CREATE PUBLIC SYNONYM' or privilege = 'CREATE PUBLIC SYNONYM' )
   and u.username = s.grantee
   and u.profile not like 'ND_SYS%' 
   and u.profile != 'DEFAULT'
UNION
select d.name, s.privilege, r.role, 'Role'
  from v$database d, dba_roles r, dba_sys_privs s
 where ( privilege = 'CREATE PUBLIC SYNONYM' or privilege = 'CREATE PUBLIC SYNONYM' )
   and r.role = s.grantee
   and r.role not in ('DBA', 'RESOURCE', 'ND_DBA_S_ROLE', 'ND_RESOURCE_S_ROLE', 'IMP_FULL_DATABASE', 'OLAP_USER')
 /
 
 exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

