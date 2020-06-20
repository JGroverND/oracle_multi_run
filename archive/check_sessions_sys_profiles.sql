--
--
--
column name             format a10
column profile          format a30
column resource_name    format a25
column limit            format a15

set linesize 300
set pagesize 0
set trimout on
set heading off
set feedback off
--
--
--
select name, profile, resource_name, limit
  from v$database, dba_profiles
 where ( profile like 'ND_SYS%' or profile = 'DEFAULT' )
   and resource_name = 'SESSIONS_PER_USER'
 order by profile
/
--
--
--
exit;

