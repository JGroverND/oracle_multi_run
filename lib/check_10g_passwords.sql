-- ---------------------------------------------------------------------
-- File: check_template.sql
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
set serveroutput on
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
select d.name || ',' ||
       v.banner || ',' ||
       to_char(sysdate, 'YYYY-MM-DD') || ',' ||
       u.username|| ',' ||
       null || ',' ||
       u.password_versions || ',' ||
       u.profile || ',' ||
       u.account_status || ',' ||
       to_char(u.created, 'YYYY-MM-DD') as "csv data"
  from dba_users u
  join v$database d on 1=1
  join v$version v on v.banner like 'Oracle%'
 where u.password_versions = '10G '
   and u.account_status = 'OPEN'
   and u.profile not like 'ND_USR%'
 order by u.username;

exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------
