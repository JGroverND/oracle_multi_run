-- ---------------------------------------------------------------------
-- File: check_logonaudits.sql
-- Desc:
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set pagesize 999
set linesize 300
set trimout on
set heading on
set feedback off
set termout on

--
--
--
column  database        format a10
column  profile         format a24
column  username        format a24
column  host            format a30
column  osuserid        format a10
column  logins          format 99999
column  "from date"     format a22
column  "thru date"     format a22

--
--
--
select d.name "database",
       u.profile,
       l.username,
       l.machinename "host",
       l.osuserid,
       l.program,
       count(*) "logins",
       TO_CHAR(min(l.timestamp), 'DD-MON-YYYY HH24:MI:SS') "from date",
       TO_CHAR(max(l.timestamp), 'DD-MON-YYYY HH24:MI:SS') "thru date"
  from ndrepoadmin.logonaudittable l, 
       dba_users u, 
       v$database d
 where u.username = l.username
 group by d.name, u.profile, l.username, l.machinename, l.osuserid, l.program 
 order by d.name, u.profile, l.username, l.machinename, l.osuserid, l.program ;
 
 exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

