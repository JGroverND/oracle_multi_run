--
--
--
set linesize 300
set pagesize 0
set head off
set trimout on

column d.name           format a10
column p.granted_role   format a10
column u.username       format a20
column u.profile        format a20
column u.account_status format a10

select name, count(*) from dba_roles, v$database where role = 'ND_CONNECT_S_ROLE' group by name;

exit;
