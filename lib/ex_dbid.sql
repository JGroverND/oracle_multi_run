-- ---------------------------------------------------------------------
-- File: sql/ex_dbid.sql
-- Desc:
--
-- Audit Trail:
-- 14-JUN-2016  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set pagesize 0
set linesize 300
set trimout on
set heading off
set feedback off

--
-- get dbid and name
--
select 'insert into syslog.dbid_map (database_id, database_name) values (' || dbid || ',''' || name || ''');' SQL
  from v$database
/
 
exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

