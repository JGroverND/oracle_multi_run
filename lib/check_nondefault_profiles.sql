-- ---------------------------------------------------------------------
-- File: sql/check_nondefault_profiles.sql
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
column  limit           format a10
column  database        format a10
column  resource_name   format a30
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
select d.name||','||p.profile||','||p.resource_name||','||p.limit
  from v$database d, dba_profiles p
 where p.profile not in (
       'DEFAULT',
       'ND_TMP_UNLIMITED',
       'ND_APP_OPEN_DEFAULT',
       'ND_LNK_OPEN_DEFAULT',
       'ND_SYS_OPEN_ORACLE',
       'ND_SYS_OPEN_OPERATIONS',
       'ND_OWN_OPEN_DEFAULT',
       'ND_USR_OPEN_DEFAULT',
       'ND_USR_OPEN_DBA',
       'ND_USR_OPEN_DEVELOPER',
       'ND_USR_OPEN_POWERUSER',
       'ND_APP_LOCK_DEFAULT',
       'ND_OWN_LOCK_DEFAULT',
       'ND_SYS_LOCK_ORACLE',
       'ND_USR_LOCK_DEFAULT',
       'ND_USR_LOCK_AUTHONLY')
  order by p.profile, p.resource_type, p.resource_name
 /
 
 exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

