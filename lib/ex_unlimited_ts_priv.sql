-- ---------------------------------------------------------------------
-- File: sql/ex_unlimited.sql
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

  select 'Granted To = ' || u.username || ', Privilege = ' || s.privilege "-- Exception"
    from dba_sys_privs s,
         dba_users u
   where s.privilege = 'UNLIMITED TABLESPACE'
     and u.username = s.grantee
     and (  u.profile   like    'ND_SYS%'   or
            u.profile   like    'ND_OWN%'   or
            u.profile    =      'ND_USER_OPEN_DBA' )
   order by u.profile, u.username
 /
 
 exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

