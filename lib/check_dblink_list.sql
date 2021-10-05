-- ---------------------------------------------------------------------
-- File: check_dblink_list.sql
-- Desc:
--
-- Audit Trail:
-- 05-mar-2021  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set pagesize 0
set linesize 300
set trimout on
set heading off
set feedback off
set serveroutput on

select d.name || ',' ||
       l.owner || ',' ||
       u.password_versions || ',' ||
       u.account_status || ',' ||
       l.db_link || ',' ||
       l.host || ',' ||
       l.username
  from dba_db_links l
  join dba_users u on u.username = l.owner
  join v$database d on 1=1
/
