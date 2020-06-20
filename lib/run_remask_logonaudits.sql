-- ---------------------------------------------------------------------
-- File: sql/run_remask_logonaudits.sql
-- Desc:
--
-- Audit Trail:
-- 15-jan-2010  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set serveroutput on
set linesize 512
set trimout on
set verify off
set showmode off

begin
  dbms_output.enable(null);
--
--
--
  ndrepoadmin.nd_logit_util.remask_logonaudits('AUTO');
--
--
--
end;
/

exit ;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

