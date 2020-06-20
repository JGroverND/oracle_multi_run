-- ---------------------------------------------------------------------
-- File: sql/ex_grantanyrole.sql
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
select '"Granted to=' || s.grantee || 
       '"' "-- Exception"
  from v$database d, dba_users u, dba_sys_privs s
 where ( privilege = 'GRANT ANY ROLE' or privilege = 'GRANT ANY PRIVILEGE' )
   and u.username = s.grantee
   and ( u.profile like 'ND_SYS%' )
union
select '"Granted to=' || s.grantee || 
       '"' "-- Exception"
  from v$database d, dba_roles r, dba_sys_privs s
 where ( privilege = 'GRANT ANY ROLE' or privilege = 'GRANT ANY PRIVILEGE' )
   and r.role = s.grantee
/
 
exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

