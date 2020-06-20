-- ---------------------------------------------------------------------
-- File: sql/fix_prod_parameters.sql
-- Desc:
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
alter system set sql92_security=true scope=spfile sid='*' ;
alter system set resource_limit=true scope=spfile sid='*' ;
alter system set os_authent_prefix=true scope=spfile sid='*' ;
alter system set audit_sys_operations=true scope=spfile sid='*' ;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------


