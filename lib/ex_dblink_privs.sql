-- ---------------------------------------------------------------------
-- File: sql/ex_dblink_privs.sql
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
-- select "Param = " || value || ', Param = ' || value "-- Exception"
select '"Granted To=' || u.username ||  '"'
-- select d.name, u.username, u.profile, s.privilege
  from v$database d, dba_sys_privs s, dba_users u
 where u.username = s.grantee
   and ( u.profile like 'ND_SYS%' or u.profile = 'ND_USR_OPEN_DBA' )
   and s.privilege like '%DATABASE LINK%'
union
select '"Granted To=' || r.role || '"'
-- select d.name, r.role, 'Role', d.privilege
  from v$database d, dba_sys_privs s, dba_roles r
 where r.role = s.grantee
   and r.role in ('DBA', 'RESOURCE', 'IMP_FULL_DATABASE', 'RECOVERY_CATALOG_OWNER', 'ND_ODS_IR_TEAM_S_ROLE' )
   and s.privilege like '%DATABASE LINK%'
/

exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

