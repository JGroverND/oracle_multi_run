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
set termout on
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
column  account_status  format a30
column  privilege       format a60
column  param           format a30
column  value           format a30

--
--
--
with
all_admin_privs as (
select grantee
      ,'table' priv_type
      ,privilege || ' on ' || owner || '.' || table_name privilege
  from dba_tab_privs
 where grantable = 'YES'
union
select grantee
      ,'column' priv_type
      ,privilege || ' on ' || owner || '.' || table_name || '.' || column_name privilege
  from dba_col_privs
 where grantable = 'YES'
union
select grantee
      ,'system' priv_type
      ,privilege
  from dba_sys_privs
 where admin_option = 'YES'
)
select sysdate
      ,name
      ,username
      ,profile
      ,account_status
      ,privilege
  from all_admin_privs
  join dba_users on dba_users.username = all_admin_privs.grantee
  join v$database on 1=1
 where profile not like 'ND_SYS%'
   and profile not like 'ND_OWN%'
   and profile not like '%BANNER'
   and profile <> 'ND_USR_OPEN_DBA'
   and profile <> 'DEFAULT'
;

-- exit ;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------
