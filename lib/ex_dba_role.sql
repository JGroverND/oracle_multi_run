-- ---------------------------------------------------------------------
-- File: sql/ex_dba.sql
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
select '"Granted to=' || s.grantee || '"' "-- Exception"
  from v$database d, dba_users u, dba_role_privs s
 where s.granted_role = 'DBA'
   and u.username = s.grantee
   and ( u.profile like 'ND_SYS%' or u.profile = 'ND_USR_OPEN_DBA' )
/
 
exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

