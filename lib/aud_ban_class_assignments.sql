-- ---------------------------------------------------------------------
-- File: aud_ban_class_assignments.sql
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
set markup HTML off
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
column  privilege       format a22
column  param           format a30
column  value           format a30

--
--
--
with
non_inb_users as (
select username
      ,profile
  from dba_users
 where profile != 'ND_USR_OPEN_INBUSER'
   and profile != 'DEFAULT'
   and profile not like '%BANNER'
   and profile not like '%DEVELOPER'
   and profile not like '%POWERUSER'
   and profile not like '%DBA'
   and profile not like '%QA'
),
banner_classes_assigned as (
select c.gurucls_userid netid
      ,c.gurucls_class_code banner_class
  from bansecr.gurucls c
 where c.gurucls_class_code not like 'NDFI%'
   and c.gurucls_class_code != 'GGN_ALL_BUY_ND_ONLY_C'
)
select 'alter user ' || banner_classes_assigned.netid || ' profile ND_USR_OPEN_INBUSER;' "profile INB users"
--      ,banner_classes_assigned.netid netid
--      ,non_inb_users.profile
--      ,banner_classes_assigned.banner_class
  from banner_classes_assigned
  join non_inb_users on (( non_inb_users.username = banner_classes_assigned.netid)
                     and (banner_classes_assigned.banner_class = 'GGN_ALL_USERS_C'))
 order by banner_classes_assigned.netid
         ,banner_classes_assigned.banner_class
;

exit ;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------
