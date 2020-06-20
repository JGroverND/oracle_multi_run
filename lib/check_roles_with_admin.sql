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
select r.grantee||','||r.granted_role
  from v$database d, dba_role_privs r
 where r.ADMIN_OPTION = 'YES'
/
--
--
--
exit;

