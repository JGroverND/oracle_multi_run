--
--
--
column name format a10
column username format a20
column profile format a20
column account_status format a20

set lines 100
set trimout on

select name, username, profile, account_status
  from dba_users, v$database
 where profile = 'DEFAULT';

exit;

