-- ---------------------------------------------------------------------
-- File: check_olap.sql
-- Desc:
--
-- Audit Trail:
-- 26-Jan-2010  John Grover
--  - Original Code see metalink note 739032.1
-- ---------------------------------------------------------------------
set pagesize 55
set linesize 300
set trimout on
set heading off
set feedback off

--
--
--
col name      format a10

col parl_val  format a40

col FEATURE   format a40
col FROM      format a20
col THRU      format a20

col comp_id   format a10
col comp_name format a30
col version   format a15
col status    format a10
col owner     format a10
col aw_name   format a20

-- Get database name in the log
select 'Database: ' || name
  from v$database;

-- Is OLAP supported?
select 'parameter ' || parameter || ' is set to ' || value
  from v$OPTION
 where PARAMETER = 'OLAP';

-- When was it used?
set heading on
select name "FEATURE", 
       first_usage_date "FROM", 
       last_usage_date  "THRU"
  from DBA_FEATURE_USAGE_STATISTICS
 where name like '%OLAP%';

-- In what state is it?
select comp_id, comp_name, version, status
  from dba_registry
 where comp_name like '%OLAP%';
       
-- Who has Analytic Workspaces? (AWs)
select owner, aw_name 
  from dba_aws
 order by 1, 2;

exit;

