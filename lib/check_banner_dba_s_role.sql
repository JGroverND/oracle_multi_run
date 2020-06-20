-- ---------------------------------------------------------------------
-- File: sql/check_banner_dba_s_role.sql
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
  select name||','||username||','||granted_role||','||profile "-- data"
    from v$database, dba_role_privs, dba_users
   where granted_role = 'DBA'
     and username = grantee
     and ( profile like '%BANNER%' or profile = 'ND_APP_OPEN_SSB' or username = 'GENLPRD')
/
 
 exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

