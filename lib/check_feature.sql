-- ---------------------------------------------------------------------
-- File: check_feature.sql
-- Desc:
--
-- Audit Trail:
-- 26-Jan-2010  John Grover
--  - Original Code see metalink note 739032.1
-- ---------------------------------------------------------------------
set pagesize 999
set linesize 300
set trimout on
set heading off
set feedback off

--
--
--
col name      format a10

col parl_val  format a40

col FEATURE   format a45
col FROM      format a20
col THRU      format a20

col comp_id   format a10
col comp_name format a30
col version   format a15
col status    format a10
col owner     format a10
col aw_name   format a20

-- Get database name in the log
select '--------------------------------  Database: ' || name || '  ---------------------------------'
  from v$database;

-- When was it used?
set heading on
select d.name "Database",
       f.name "FEATURE", 
       first_usage_date "FROM", 
       last_usage_date  "THRU"
  from DBA_FEATURE_USAGE_STATISTICS f, v$database d
 order by last_usage_date, name;

exit;

