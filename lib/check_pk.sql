-- ---------------------------------------------------------------------
-- File: check_reporting_team.sql
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
column tabale_name format A20
column Mbytes      format 99,999
column num_rows    format 99,999,999

SELECT DISTINCT
       TAB.TABLE_NAME
       ROUND(TAB.BLOCKS / 128) "Mbytes",
       TAB.NUM_ROWS
  FROM DBA_TABLES TAB
 WHERE (TAB.BLOCKS / 128) > 256
   AND TAB.OWNER IN (
         SELECT USERNAME
         FROM DBA_USERS
         WHERE PROFILE LIKE 'ND_OWN%_BANNER'
       )
   AND NOT EXISTS (
         SELECT 1
         FROM DBA_CONSTRAINTS CON
         WHERE CON.TABLE_NAME = TAB.TABLE_NAME
         AND CON.CONSTRAINT_TYPE = 'P'
       )
/
exit;


--
--
--

exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

