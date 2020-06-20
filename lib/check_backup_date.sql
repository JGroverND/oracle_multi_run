-- ---------------------------------------------------------------------
-- File: check_backup_date.sql
-- Desc:
--
-- Audit Trail:
-- 26-Apr-2010  John Grover
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
column  backup_date     format a30
column  begin_time      format a30
column  snap_time       format a30
column  end_time        format a30

--
--
--
select
  name,
  TO_CHAR(backup_date, 'DD-MON-YYYY HH24:MI:SS') backup_date,
  TO_CHAR(begin_time, 'DD-MON-YYYY HH24:MI:SS') begin_time,
  TO_CHAR(snap_time, 'DD-MON-YYYY HH24:MI:SS') snap_time,
  TO_CHAR(end_time, 'DD-MON-YYYY HH24:MI:SS') end_time,
  backup_status
  from NDREPOADMIN.db_backups, v$database
 order by backup_date;

exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

