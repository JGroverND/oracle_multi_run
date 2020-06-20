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
select 'DBA,' || name || ',' || grantee || ',' || privilege || ',' || null || ',' || null || ',' || admin_option
  from v$database, dba_sys_privs 
 where grantee in ( 'FAHMED', 'JGROVER', 'KBANSAL', 'MCHUA', 'MKULKARN', 'NDOSMANN', 'NELIA', 'TPEREZ1', 'YJIANG1')
union
select 'DBA,' || name || ',' || grantee || ',' || privilege || ',' || owner || ',' || table_name || ',' || grantable
  from v$database, dba_tab_privs
 where grantee in ( 'FAHMED', 'JGROVER', 'KBANSAL', 'MCHUA', 'MKULKARN', 'NDOSMANN', 'NELIA', 'TPEREZ1', 'YJIANG1')
union
select 'DBA,' || name || ',' || grantee || ',' || granted_role || ',' || null || ',' || null || ',' || admin_option
  from v$database, dba_role_privs
 where grantee in ( 'FAHMED', 'JGROVER', 'KBANSAL', 'MCHUA', 'MKULKARN', 'NDOSMANN', 'NELIA', 'TPEREZ1', 'YJIANG1')
/
--
--
--
exit;

