-- ---------------------------------------------------------------------
-- File: tmp_chk_old_accounts.sql
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
select to_char(sysdate, 'YYYY-MM-DD') || ', ' ||
       d.name || ', ' ||
       u.username || ', ' ||
       u.profile || ', ' ||
       to_char(u.created, 'YYYY-MM-DD') || ', ' ||
       nvl(to_char(u.last_login, 'YYYY-MM-DD'), 'never') as DATA
  from v$database d,
       dba_users u
 where u.username in ('ND_DBPROTECT_USER', 
                      'ND_REPO_EXTRACT_USER', 
                      'ND_SENTRIGO_USER',
                      'NDREPOADMIN', 
                      'ND_ORAPROBE_ADMIN')
 order by u.username
/

exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

