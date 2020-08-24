-- ---------------------------------------------------------------------
-- File: check_dbid.sql
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

--
--
--
select dbid
      ,name
      ,database_role
 from v$database;

exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------
