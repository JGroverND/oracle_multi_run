-- ---------------------------------------------------------------------
-- File: aud_admin_grants.sql
-- Desc:
--
-- Audit Trail:
-- 15-jan-2010  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set autocommit off
set define on
set echo off
set feedback off
set heading off
set linesize 120
set markup csv on
set newpage none
set pagesize 0
set serveroutput on
set showmode off
set termout off
set timing off
set time off
set trimspool on
set trimout on
set verify off
set wrap off

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
with
tab_privs as (
select username
     ,profile
     ,account_status
     ,count(0) as grantable_count -- privilege || ' on ' || owner || '.' || table_name "privilege", grantable
  from dba_users
 inner join dba_tab_privs on grantee = username
 where profile not like 'ND_SYS%'
   and profile not like 'ND_OWN%'
   and profile not like '%BANNER'
   and profile <> 'ND_USR_OPEN_DBA'
   and profile <> 'DEFAULT'
   and grantable = 'YES'
 group by username, profile, account_status
),
sys_privs as (
select username
      ,profile
      ,account_status
      ,count(0) as grantable_count -- privilege, admin_option
  from dba_users
 inner join dba_sys_privs on grantee = username
 where profile not like 'ND_SYS%'
   and profile not like 'ND_OWN%'
   and profile not like '%BANNER'
   and profile <> 'ND_USR_OPEN_DBA'
   and profile <> 'DEFAULT'
   and admin_option = 'YES'
 group by username, profile, account_status
)
select sysdate
      ,name
      ,tab_privs.username
      ,tab_privs.profile
      ,tab_privs.account_status
      ,coalesce(tab_privs.grantable_count, 0) tbl_grantable_count
      ,coalesce(sys_privs.grantable_count, 0) sys_grantable_count
  from tab_privs
  join v$database on 1=1
  left outer join sys_privs on sys_privs.username = tab_privs.username
 order by tab_privs.username
;

exit ;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------
