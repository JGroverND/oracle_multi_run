-- ---------------------------------------------------------------------
-- File: check_db_size.sql
-- Desc:
--
-- Audit Trail:
-- 05-18-2021 John Grover
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
select name ||','||
       Reserved_Gb ||','||
       (Reserved_Gb - Free_Gb) ||','||
       Free_Gb
 from ( select
         (select sum(bytes/(1024*1024*1024)) from dba_data_files) as Reserved_Gb,
         (select sum(bytes/(1024*1024*1024)) from dba_free_space) as Free_Gb
          from dual
      )
  join v$database on 1=1
;
--
--
--

exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------
