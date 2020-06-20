-- ---------------------------------------------------------------------
-- File: sql/ex_source_as_sys.sql
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
select distinct 'Granted To = ' || grantee "-- Exception"
  from dba_sys_privs
 where privilege in (
'CREATE ANY PROCEDURE',
'ALTER ANY PROCEDURE',
'EXECUTE ANY PROCEDURE',
'ALTER ANY TRIGGER',
'CREATE ANY TRIGGER')
/
 
exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

