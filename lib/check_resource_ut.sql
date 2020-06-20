-- ---------------------------------------------------------------------
-- File: sql/check_resource_ut.sql
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
SELECT d.name, u.username, u.profile, s.granted_role, s.admin_option
  FROM gv$database d, dba_role_privs s, dba_users u
 WHERE s.granted_role = 'ND_RESOURCE_S_ROLE'
   and username = grantee
   AND ( profile not like 'ND_SYS%' and profile != 'DEFAULT' )
   and not exists ( select 1 from dba_sys_privs p where p.privilege = 'UNLIMITED TABLESPACE' and p.grantee = s.grantee)
 ORDER BY profile;

 /
 
 exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

