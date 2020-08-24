-- ---------------------------------------------------------------------
-- File: sql/aud_dba_staff.sql
-- Desc: List non-dba roles granted to DBA Staff
--
-- Audit Trail:
-- 21-aug-2020  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set autocommit off
set define on
set echo off
set feedback off
set heading off
set linesize 120
set markup csv on
set newpage none
set pagesize 0
set serveroutput on
set showmode off
set termout on
set timing off
set time off
set trimspool on
set trimout on
set verify off
set wrap off

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

--
-- List non-dba roles granted to DBA Staff
--
select sysdate, name, username, profile, granted_role
  from dba_users
  join v$database on 1=1
  join dba_role_privs on grantee = username
 where profile = 'ND_USR_OPEN_DBA'
   and granted_role not in (
     'DBA',
     'ND_DBA_S_ROLE',
     'BAN_DEFAULT_CONNECT',
     'BAN_DEFAULT_M',
     'BAN_DEFAULT_NO_ACCESS',
     'BAN_DEFAULT_Q')
 order by username, granted_role
;

exit ;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------
