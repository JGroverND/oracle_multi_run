--
--
--
column name format a10
column resource_name format a20
column limit format a30
column profile format a30

set lines 200
set trimout on

select name, resource_name, limit, profile
  from dba_profiles, v$database
 where resource_name = 'SESSIONS_PER_USER'
/

exit;

