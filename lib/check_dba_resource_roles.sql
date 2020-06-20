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
   and profile not like 'ND_SYS%' and profile != 'ND_USR_OPEN_DBA'
   and profile != 'DEFAULT'
   and granted_role in ('DBA', 'RESOURCE', 'CONNECT')
UNION
select d.name, 'ROLE', r.role, p.granted_role
  from v$database d, dba_role_privs p, dba_roles r
 where r.role = p.grantee
   and p.granted_role in ('DBA', 'RESOURCE', 'CONNECT')
/
--
--
--
exit;

