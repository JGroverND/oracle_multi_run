--
--
--
column name             format a10
column profile          format a30
column privilege        format a25
column grantee          format a30
column username         format a30
column admin_option     format a15

set linesize 300
set pagesize 0
set trimout on
set heading off
set feedback off
--
--
--
select name, profile, username, granted_role
  from v$database, dba_users, dba_role_privs
 where username = grantee
   and profile not like 'ND_SYS%'
   and profile != 'DEFAULT'
   and profile != 'ND_USR_OPEN_DBA'
   and granted_role = 'DBA'
/
--
--
--
exit;

