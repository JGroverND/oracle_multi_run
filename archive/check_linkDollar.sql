--
--
--
column name format a10
column grantee format a20
column privilege format a20

set lines 100
set trimout on

select name, grantee, privilege from dba_tab_privs, v$database where owner = 'SYS' and table_name = 'LINK$' order by grantee;

exit
