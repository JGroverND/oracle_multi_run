-- ---------------------------------------------------------------------
-- File: aud_ban_inbusers.sql
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
set markup CSV on
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
inb_users as (
select username
      ,account_status
  from dba_users
 where profile = 'ND_USR_OPEN_INBUSER'
),
banner_classes_assigned as (
select c.gurucls_userid netid
      ,c.gurucls_class_code banner_class
 from bansecr.gurucls c
)
select sysdate
      ,name
      ,inb_users.username
      ,inb_users.account_status
      ,coalesce(banner_classes_assigned.banner_class, 'no classes assigned') banner_class
  from inb_users
  join v$database on 1=1
  left outer join banner_classes_assigned on banner_classes_assigned.netid = inb_users.username
 where banner_classes_assigned.banner_class is null
    or inb_users.account_status != 'OPEN'
 order by inb_users.username
      ,coalesce(banner_classes_assigned.banner_class, 'no classes assigned')
;

exit ;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------
