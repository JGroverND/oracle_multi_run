-- ---------------------------------------------------------------------
-- File: check_reporting_team.sql
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

begin
  dbms_output.enable(null);
  nd_sec_util.clone_user('AMANIER1', 'AMANIER1', 'safe');
  nd_sec_util.clone_user('CFREDER2', 'CFREDER2', 'safe');
  nd_sec_util.clone_user('JDOSMANN', 'JDOSMANN', 'safe');
  nd_sec_util.clone_user('RANDY',    'RANDY',    'safe');
  nd_sec_util.clone_user('SMARTI11', 'SMARTI11', 'safe');
  nd_sec_util.clone_user('TWILSON2', 'TWILSON2', 'safe');
end;
/
 
 exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

