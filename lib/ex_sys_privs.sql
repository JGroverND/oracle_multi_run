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
set feeback off
--
-- "Granted to", "Privilege'
--
select 'Granted to = ' || username || ', Privilege = ' || privilege "--"
  from dba_sys_privs, dba_users
 where username = grantee
   and profile like 'ND_SYS%'
/
--
--
--
exit;

