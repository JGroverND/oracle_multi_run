-- ---------------------------------------------------------------------
-- File: check_dbid_map.sql
-- Desc:
--
-- Audit Trail:
-- 20-aug-2020  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set pagesize 0
set linesize 300
set trimout on
set feedback off
set serveroutput on
--
--
--
column  dbid            format 99999999999
column  name            format a9
column  database_role   format a16
column  SQL_CMD         format a100

--
-- select dbid
--       ,name
--       ,database_role
--  from v$database;

select 'insert into syslog.dbid_map (database_id, database_name) values (' || dbid || ',''' || name || ''');' SQL_CMD from v$database
/

exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------
