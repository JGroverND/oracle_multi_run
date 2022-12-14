-- ---------------------------------------------------------------------
-- File: sql/check_systs.sql
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
select d.name, 
       u.username, 
       u.profile, 
       (select count(*) 
          from dba_tables 
         where owner = u.username 
           and tablespace_name = 'SYSTEM') tables, 
       (select count(*) 
          from dba_indexes 
         where owner = u.username 
           and tablespace_name = 'SYSTEM') indexes
  from v$database d, 
       dba_users u
 where default_tablespace = 'SYSTEM'
 /
 
 exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

