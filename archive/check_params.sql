--
--
--
column database     format a10
column name         format a30
column value        format a10

set linesize 300
set pagesize 0
set trimout on
set heading off
set feedback off
--
--
--
select d.name as database, p.name, p.value
  from v$database d, v$parameter p
 where ( upper(p.name) = 'RESOURCE_LIMIT' and p.value != 'TRUE' )
    or ( upper(p.name) = 'AUDIT_SYS_OPERATIONS' and p.value != 'TRUE' )
    or ( upper(p.name) = 'SQL92_SECURITY' and p.value != 'TRUE' )
    or ( upper(p.name) = 'OS_AUTHENT_PREFIX' and p.value != '' )
/
--
--
--
exit;

