-- ---------------------------------------------------------------------
-- File: run_auto_mask.sql
-- Desc:
--
-- Audit Trail:
-- 09-Nov-2009  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set serveroutput on
set linesize 512
set trimout on
set verify off
set showmode off

begin
  declare
  v_mode    varchar2(10)    := 'safe' ;
  begin
    v_mode := lower('&1');
    dbms_output.enable(null);

    ndrepoadmin.nd_logit_util.auto_mask(0, 3600, v_mode);
  end ;
end ;
/

exit ;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

