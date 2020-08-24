-- ---------------------------------------------------------------------
-- File: sql/template_run.sql
-- Desc:
--
-- Audit Trail:
-- 15-jan-2010  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set autocommit off
  -- AUTO[COMMIT] {OFF|ON|IMM[EDIATE]|n}
set define on
  -- DEF[INE] {&|c|ON|OFF}
set echo off           
  -- ECHO {OFF|ON}
set feedback off
  -- FEED[BACK] {6|n|ON|OFF}
set heading off
  -- HEA[DING] {ON|OFF}
set linesize 120
  -- LIN[ESIZE] {80|n}
set markup HTML off
  -- MARK[UP] HTML [OFF|ON] [HEAD text] [BODY text]
  -- [TABLE text] [ENTMAP {ON|OFF}] [SPOOL {OFF|ON}]
  -- [PRE[FORMAT] {OFF|ON}]
set newpage none
  -- NEWP[AGE] {1|n|NONE}
set pagesize 0
  -- PAGES[IZE] {14|n}
set serveroutput on
  -- SERVEROUT[PUT] {ON|OFF} [SIZE {n | UNLIMITED}]
  -- [FOR[MAT] {WRA[PPED] | WOR[D_WRAPPED] | TRU[NCATED]}]
set showmode off
  -- SHOW[MODE] {OFF|ON}
set termout off
  -- TERM[OUT] {ON|OFF}
set timing off
  -- TIMI[NG] {OFF|ON}
set time off
  -- TI[ME] {OFF|ON}
set trimspool on
  -- TRIMS[POOL] {OFF|ON}
set trimout on
  -- TRIM[OUT] {ON|OFF}
set verify off
  -- VER[IFY] {ON|OFF}
set wrap off
  -- WRA[P] {ON|OFF}

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
