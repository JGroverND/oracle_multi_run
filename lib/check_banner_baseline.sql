-- ---------------------------------------------------------------------
-- File: sql/check_banner_baseline.sql
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
select d.name || ', ' || u.username || ', ' || u.profile || ', ' || u.account_status
  from v$database d, dba_users u
 where u.profile like '%BANNER%'
    or ( u.username like '%MGR'  and u.username not like 'ND%' )
    or ( u.username like '%USER' and u.username not like 'ND%' )
    or ( u.username like '%USR'  and u.username not like 'ND%' )
    or ( u.username like '%PRD'  and u.username not like 'ND%' )
    or ( u.username like '%DAT'  and u.username not like 'ND%' )
    or ( u.username like '%ARC'  and u.username not like 'ND%' )
 order by username
/
 
 exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

