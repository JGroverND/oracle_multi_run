--
--
--
column name             format a10
column profile          format a30
column privilege        format a25
column grantee          format a30
column admin_option     format a15

set linesize 300
set pagesize 0
set trimout on
set heading off
set feedback off
--
--
--
select name || ',' || profile || ',' || grantee || ',' || admin_option || ',' || privilege
  from v$database, dba_sys_privs, dba_users
 where privilege in ( 'GRANT ANY ROLE', 'GRANT ANY PRIVILEGE' )
   and username = grantee
UNION
select name || ', ROLE, ' || grantee || ',' || admin_option || ',' || privilege
  from v$database, dba_sys_privs, dba_roles
 where privilege in ( 'GRANT ANY ROLE', 'GRANT ANY PRIVILEGE' )
   and role = grantee
/
--
--
--
exit;

