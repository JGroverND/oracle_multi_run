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
select 'Granted To=' || grantee
  from v$database d, dba_sys_privs p, dba_users u
 where u.username = p.grantee
   and privilege <> 'UNLIMITED TABLESPACE'
/
--
--
--
exit;

