-- ---------------------------------------------------------------------
-- File: sql/aud_dba_users.sql
-- Desc: List users with DBA privileges
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
column name            format a10
column database        format a10
column username        format a30
column grantee         format a30
column role            format a30
column granted_role    format a30
column profile         format a30
column privilege       format a22
column param           format a30
column value           format a30
column sysdate         date
--
-- List users with DBA privileges
--
select sysdate, name, username, granted_role, profile
  from dba_users
  join v$database on 1=1
  join dba_role_privs on grantee = username
 where granted_role in ('DBA', 'ND_DBA_S_ROLE')
   and profile not like '%BANNER'
   and oracle_maintained = 'N'
 order by granted_role, profile
;

exit ;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------
