-- ---------------------------------------------------------------------
-- File: run_autodeploy_user.sql
-- Desc:
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
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
-- ##### Begin recreate user in safe mode 
create user ND_AUTODEPLOY_USER 
  identified by KQYI6F6AXE9NGPYWU570H60_W2VNG7
  default tablespace USERS 
  temporary tablespace TEMP 
  profile ND_APP_OPEN_DEFAULT account unlock ;

-- ##### End recreate user
-- ##### Begin regrant all in safe mode
-- ##### From: ND_AUTODEPLOY_USER
-- ##### To:   ND_AUTODEPLOY_USER
grant ND_CONNECT_S_ROLE to ND_AUTODEPLOY_USER ;
grant ND_DBA_S_ROLE to ND_AUTODEPLOY_USER ;
-- ##### End regrant all

--
--
--

exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

