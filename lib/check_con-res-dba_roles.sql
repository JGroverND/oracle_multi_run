--
--
--
column name             format a10
column username         format a30
column granted_role     format a25
column profile          format a30
column admin_option     format a15

set linesize 300
set pagesize 0
set trimout on
set heading off
set feedback off
--
--
--
  select name, username, granted_role, profile
    from v$database, dba_role_privs, dba_users
   where granted_role in ('CONNECT', 'RESOURCE', 'DBA')
     and username = grantee
     and profile not like 'ND_SYS%'
     and profile != 'ND_USR_OPEN_DBA'
     and profile != 'DEFAULT'
/
--
--
--
exit;

