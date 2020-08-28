-- ---------------------------------------------------------------------
-- File: template_run.sql
-- Desc:
--
-- Audit Trail:
-- 15-jan-2010  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set autocommit off
set define on
set echo off
set feedback off
set heading off
set linesize 120
set markup HTML off
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
--
--


exit ;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------
