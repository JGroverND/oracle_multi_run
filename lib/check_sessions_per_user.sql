-- ---------------------------------------------------------------------
-- File: sql/check_sessions_per_user.sql
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
select d.name || ', ' || p.profile || ', ' || p.resource_name || ', ' || p.limit
  from v$database d, dba_profiles p
 where resource_name = 'SESSIONS_PER_USER'
 order by profile ;

 /
 
 exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

