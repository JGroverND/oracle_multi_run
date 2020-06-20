-- ---------------------------------------------------------------------
-- File: sql/ex_pubsyn_privs.sql
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
       '","Privilege=' || s.privilege || 
       '"' "-- Exception"
  from v$database d, dba_users u, dba_sys_privs s
 where ( privilege = 'CREATE PUBLIC SYNONYM' or privilege = 'DROP PUBLIC SYNONYM' )
   and u.username = s.grantee
   and u.profile like 'ND_SYS%'
UNION
select '"Granted to=' || s.grantee || 
       '","Privilege=' || s.privilege || 
       '"' "-- Exception"
  from v$database d, dba_roles r, dba_sys_privs s
 where ( privilege = 'CREATE PUBLIC SYNONYM' or privilege = 'DROP PUBLIC SYNONYM' )
   and r.role = s.grantee   
   and r.role in ('DBA', 'RESOURCE', 'ND_DBA_S_ROLE', 'ND_RESOURCE_S_ROLE', 'IMP_FULL_DATABASE', 'OLAP_USER')

/

exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

