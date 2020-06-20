-- ---------------------------------------------------------------------
-- File: run_drop_user_mkulkarn.sql
-- Desc:
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set pagesize 0
set linesize 300
set trimout on

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
drop user mkulkarn cascade ;
exit;

select name, username, password, account_status
  from dba_users, v$database 
 where username = 'MKULKARN' ;

select owner, object_type, object_name
  from dba_objects
 where owner = 'MKULKARN' ;
 
exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

