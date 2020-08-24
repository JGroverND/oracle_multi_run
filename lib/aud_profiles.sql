-- ---------------------------------------------------------------------
-- File: sql/aud_profiles.sql
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
set markup csv on
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
set termout on
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

-- DEFAULT
-- ND_APP_LOCK_DEFAULT
-- ND_APP_OPEN_DEFAULT
-- ND_LNK_OPEN_DEFAULT
-- ND_OWN_LOCK_DEFAULT
-- ND_OWN_OPEN_DEFAULT
-- ND_SYS_LOCK_DEFAULT
-- ND_SYS_LOCK_ORACLE
-- ND_SYS_OPEN_DEFAULT
-- ND_SYS_OPEN_OPERATIONS
-- ND_SYS_OPEN_ORACLE
-- ND_SYS_OPEN_PIPES
-- ND_USR_LOCK_DEFAULT
-- ND_USR_OPEN_DBA
-- ND_USR_OPEN_DEFAULT
-- ND_USR_OPEN_DEVELOPER
-- ND_USR_OPEN_POWERUSER
-- ORA_STIG_PROFILE

-- specific to Banner
-- ND_APP_LOCK_BANNER
-- ND_APP_OPEN_BANNER
-- ND_APP_OPEN_DATA_INTEGRATOR
-- ND_APP_OPEN_SSB
-- ND_OWN_LOCK_BANNER
-- ND_OWN_OPEN_BANNER
-- ND_OWN_OPEN_DATA_INTEGRATOR
-- ND_USR_LOCK_BUYND
-- ND_USR_LOCK_EFFORT_CERT
-- ND_USR_LOCK_PEOPLE_EZ
-- ND_USR_OPEN_BOSSCARS
-- ND_USR_OPEN_EPRINT
-- ND_USR_OPEN_INBUSER
-- ND_USR_OPEN_QA

-- specific to ADVANCE
-- ND_USR_OPEN_ADVANCE_DEV
-- ND_USR_OPEN_ADVUSER
-- ND_USR_OPEN_DATASUPPORT
-- ND_USR_OPEN_SMARTCALL
-- ND_USR_OPEN_SMARTCALLMGR
-- ND_USR_OPEN_TRAINING

-- -----------------------------------------------------------------------------
-- Validate list of profiles
-- -----------------------------------------------------------------------------

-- Banner databases
select distinct sysdate, name, profile
  from dba_profiles
  join v$database on 1=1
 where (regexp_like(name, '*bnr*') or regexp_like(name, '*BNR*'))
   and profile not in (
     'DEFAULT',
     'ND_APP_LOCK_DEFAULT',
     'ND_APP_OPEN_DEFAULT',
     'ND_LNK_OPEN_DEFAULT',
     'ND_OWN_LOCK_DEFAULT',
     'ND_OWN_OPEN_DEFAULT',
     'ND_SYS_LOCK_DEFAULT',
     'ND_SYS_LOCK_ORACLE',
     'ND_SYS_OPEN_DEFAULT',
     'ND_SYS_OPEN_OPERATIONS',
     'ND_SYS_OPEN_ORACLE',
     'ND_SYS_OPEN_PIPES',
     'ND_USR_LOCK_DEFAULT',
     'ND_USR_OPEN_DBA',
     'ND_USR_OPEN_DEFAULT',
     'ND_USR_OPEN_DEVELOPER',
     'ND_USR_OPEN_POWERUSER',
     'ORA_STIG_PROFILE',
     -- specific to Banner
     'ND_APP_LOCK_BANNER',
     'ND_APP_OPEN_BANNER',
     'ND_APP_OPEN_DATA_INTEGRATOR',
     'ND_APP_OPEN_SSB',
     'ND_OWN_LOCK_BANNER',
     'ND_OWN_OPEN_BANNER',
     'ND_OWN_OPEN_DATA_INTEGRATOR',
     'ND_USR_LOCK_BUYND',
     'ND_USR_LOCK_EFFORT_CERT',
     'ND_USR_LOCK_PEOPLE_EZ',
     'ND_USR_OPEN_BOSSCARS',
     'ND_USR_OPEN_EPRINT',
     'ND_USR_OPEN_INBUSER',
     'ND_USR_OPEN_QA'
)
order by profile
;

-- Advance databases
select distinct sysdate, name, profile
  from dba_profiles
  join v$database on 1=1
 where (regexp_like(name, '*adv*') or regexp_like(name, '*ADV*'))
   and profile not in (
     'DEFAULT',
     'ND_APP_LOCK_DEFAULT',
     'ND_APP_OPEN_DEFAULT',
     'ND_LNK_OPEN_DEFAULT',
     'ND_OWN_LOCK_DEFAULT',
     'ND_OWN_OPEN_DEFAULT',
     'ND_SYS_LOCK_DEFAULT',
     'ND_SYS_LOCK_ORACLE',
     'ND_SYS_OPEN_DEFAULT',
     'ND_SYS_OPEN_OPERATIONS',
     'ND_SYS_OPEN_ORACLE',
     'ND_SYS_OPEN_PIPES',
     'ND_USR_LOCK_DEFAULT',
     'ND_USR_OPEN_DBA',
     'ND_USR_OPEN_DEFAULT',
     'ND_USR_OPEN_DEVELOPER',
     'ND_USR_OPEN_POWERUSER',
     'ORA_STIG_PROFILE',
     -- specific to ADVANCE
     'ND_USR_OPEN_ADVANCE_DEV',
     'ND_USR_OPEN_ADVUSER',
     'ND_USR_OPEN_DATASUPPORT',
     'ND_USR_OPEN_SMARTCALL',
     'ND_USR_OPEN_SMARTCALLMGR',
     'ND_USR_OPEN_TRAINING'
   )
order by profile
;

-- Other databases
select distinct sysdate, name, profile
  from dba_profiles
  join v$database on 1=1
 where not regexp_like(name, '*bnr*')
   and not regexp_like(name, '*BNR*')
   and not regexp_like(name, '*adv*')
   and not regexp_like(name, '*ADV*')
   and profile not in (
    'DEFAULT',
    'ND_APP_LOCK_DEFAULT',
    'ND_APP_OPEN_DEFAULT',
    'ND_LNK_OPEN_DEFAULT',
    'ND_OWN_LOCK_DEFAULT',
    'ND_OWN_OPEN_DEFAULT',
    'ND_SYS_LOCK_DEFAULT',
    'ND_SYS_LOCK_ORACLE',
    'ND_SYS_OPEN_DEFAULT',
    'ND_SYS_OPEN_OPERATIONS',
    'ND_SYS_OPEN_ORACLE',
    'ND_SYS_OPEN_PIPES',
    'ND_USR_LOCK_DEFAULT',
    'ND_USR_OPEN_DBA',
    'ND_USR_OPEN_DEFAULT',
    'ND_USR_OPEN_DEVELOPER',
    'ND_USR_OPEN_POWERUSER',
    'ORA_STIG_PROFILE'
   )
order by profile
;

-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------
