-- ---------------------------------------------------------------------
-- File: check_audit_status.sql
-- Desc:
--
-- Audit Trail:
-- 09-OCT-2020  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set pagesize 0
set linesize 300
set trimout on
set heading off
set feedback off
set serveroutput on
--
--
--
column  name            format a10
column  database        format a10
column  username        format a30
column  grantee         format a30
column  role            format a30
column  granted_role    format a30
column  profile         format a30
column  privilege       format a22
column  param           format a30
column  value           format a30

select d.dbid, d.name, count(0)
  from v$database d
  left outer join sys.aud$ a on 1=1
 group by d.dbid, d.name;

SELECT d.dbid, d.name, p.name || ' =  ' || p.value "-- Check Param"
  FROM v$parameter p
  join v$database d on 1=1
 WHERE p.NAME LIKE '%audit%'
    OR p.NAME LIKE '%syslog%' ;

exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------
