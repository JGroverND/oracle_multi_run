-- ---------------------------------------------------------------------
-- File: sql/check_ndprobe_tabs.sql
-- Desc:
--
-- Audit Trail:
-- 29-Apr-2009  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set pagesize 0
set linesize 300
set trimout on
set heading off
set feedback off
--
-- Make sure table definition has not changed
--
select i.version        || ', ' ||
       c.owner          || ', ' ||
       c.table_name     || ', ' ||
       c.column_name    || ', ' ||
       c.column_id      || ', ' ||
       c.data_type      || ', ' ||
       c.data_length    || ', ' ||
       c.data_precision || ', ' ||
       c.data_scale     || ', ' ||
       c.default_length || ', ' ||
       c.nullable       || ', ' ||
       DBMS_UTILITY.GET_HASH_VALUE(
         c.owner||c.table_name||c.column_name||c.column_id||
         c.data_type||c.data_length||c.data_precision||c.data_scale||
         c.default_length||c.nullable, 
         1, 
         power(2,16))
  from dba_tab_cols c, v$instance i
 where c.table_name in (
       'DATABASE_PROPERTIES',
       'DBA_COL_PRIVS',
       'DBA_DATA_FILES',
       'DBA_DB_LINKS',
       'DBA_OBJECTS',
       'DBA_PROFILES',
       'DBA_ROLE_PRIVS',
       'DBA_ROLES',
       'DBA_SYS_PRIVS',
       'DBA_TABLESPACES',
       'DBA_TAB_PRIVS',
       'DBA_USERS',
       'LOGONAUDITMASK',
       'LOGONAUDITTABLE',
       'V$DATABASE',
       'V$INSTANCE',
       'V$PARAMETER',
       'V$VERSION')
 order by owner, table_name, column_id
/
 
exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

