-- ---------------------------------------------------------------------
-- File: sql/ex_template.sql
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

--
-- "Granted To", "Privilege", "Role", "Parameter", "Value"
--
select "Param = " || value || ', Param = ' || value "-- Exception"
  from v$database d
 where 
 order by 
/
 
exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

