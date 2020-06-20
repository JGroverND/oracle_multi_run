-- ---------------------------------------------------------------------
-- File: check_mask_comments.sql
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
select distinct d.name || ', ' ||
       MASK_PROFILE || ', ' ||
       MASK_USERNAME || ', ' ||
       MASK_MACHINENAME || ', ' ||
       MASK_OSUSERID || ', ' ||
       MASK_PROGRAM || ', ' ||
--                   123456789012345678901234567890
       MASK_COMMENT "Db,Prfl,Usr,Mchn,ODID,Pgm,Cmt"
  from ndrepoadmin.logonauditmask l, v$database d
 order by 1
 /

exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

