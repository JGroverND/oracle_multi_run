-- ---------------------------------------------------------------------
-- File: sql/check_template.sql
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
select name, grantee, privilege, table_name
  from v$database d, 
       dba_tab_privs t
 where t.owner = 'SYS'
   and t.table_name in ('UTL_FILE', 'UTL_SMTP', 'UTL_HTTP', 'UTL_TCP')
   and t.grantee = 'PUBLIC'
 order by 1,2,4
/
--
--
--
exit;

