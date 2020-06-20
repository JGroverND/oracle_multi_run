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
select d.name||', ROLE,'||p.grantee||','||p.admin_option||','||p.privilege
  from v$database d, dba_sys_privs p, dba_roles u
 where u.role = p.grantee
/
--
--
--
exit;

