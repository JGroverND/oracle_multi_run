-- ---------------------------------------------------------------------
-- File: sql/fix_provision_resource_s.sql
-- Desc:
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set serveroutput on
set linesize 512
set trimout on
set verify off
set showmode off

--    CREATE role ND_RESOURCE_S_ROLE;
grant CREATE PROCEDURE to ND_RESOURCE_S_ROLE;
grant CREATE SEQUENCE to ND_RESOURCE_S_ROLE;
grant CREATE SESSION to ND_RESOURCE_S_ROLE;
grant CREATE SYNONYM to ND_RESOURCE_S_ROLE;
grant CREATE TABLE to ND_RESOURCE_S_ROLE;
grant CREATE TRIGGER to ND_RESOURCE_S_ROLE;
grant CREATE VIEW to ND_RESOURCE_S_ROLE;
grant CREATE PUBLIC SYNONYM to ND_RESOURCE_S_ROLE;

exit ;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

