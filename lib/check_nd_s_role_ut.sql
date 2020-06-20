-- ---------------------------------------------------------------------
-- File: sql/check_nd_s_role_ut.sql
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
  select d.name, r.granted_role, r.grantee, u.profile
    from v$database d, dba_role_privs r, dba_users u
   where r.granted_role in ('ND_DBA_S_ROLE', 'ND_RESOURCE_S_ROLE', 'DBA', 'RESOURCE')
     and u.username = r.grantee
     and username != 'SYS'
     and not exists ( select 1 from dba_sys_privs s where s.privilege = 'UNLIMITED TABLESPACE' and s.grantee = r.grantee )
 /
 
 exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

