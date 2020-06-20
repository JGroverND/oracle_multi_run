-- ---------------------------------------------------------------------
-- File: sql/check_empty_roles.sql
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
--
--
column  name            format a10
column  reason          format a10
column  database        format a10
column  username        format a30
column  grantee         format a30
column  role            format a30
column  granted_role    format a30
column  profile         format a30
column  privilege       format a22
column  param           format a30
column  value           format a30

--
--
--
select d.name, r.role, 'No Grantee' as reason
  from v$database d, dba_roles r
 where ( select count(*) 
           from dba_role_privs p 
          where p.granted_role = r.role ) = 0 
UNION
select d.name, r.role, 'No Privs'
  from dba_roles r
 where ( select count(*) from dba_role_privs where grantee = r.role ) = 0
   and ( select count(*) from dba_sys_privs where grantee = r.role ) = 0
   and ( select count(*) from dba_tab_privs where grantee = r.role ) = 0
   and ( select count(*) from dba_col_privs where grantee = r.role ) = 0 ;
 /
 
 exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

