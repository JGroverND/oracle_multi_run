-- ---------------------------------------------------------------------
-- File: sql/check_utldep.sql
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
select d.name || ', ' ||
       p.referenced_owner || '.' || 
       p.referenced_name|| ', ' ||
       p.owner|| '.' ||
       p.name|| ', ' ||
       p.type
  from v$database d, 
       dba_dependencies p
 where p.referenced_owner = 'SYS'
   and p.referenced_name in ('UTL_FILE', 'UTL_SMTP', 'UTL_HTTP', 'UTL_TCP')
   and p.owner not in ('SYS', 'PUBLIC')
/
--
--
--
exit;

