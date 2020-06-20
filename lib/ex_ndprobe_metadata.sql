-- -----------------------------------------------------------------------------
-- File: ex_ndprobe_metadata.sql
-- Desc: Extract config data from target database
--
-- Audit Trail:
-- 09-Jun-2009 jgrover
--  - Original code
-- -----------------------------------------------------------------------------
set pagesize 0
set linesize 500
set trimout on
set heading off
set feedback off

--
-- Extract database information
-- -------------------------------------
select 'insert into ndprobeadmin.track_databases ' ||
       '(dbhost, dbname, dbinstance, version, track_start, track_end, ' ||
       'family, environment,  username, password ) values (''' ||
       v.host_name || ''', ''' ||
       d.name || ''', ''' ||
       v.instance_name || ''', ''' ||
       v.version || ''', ' ||
       'to_date(''01-Jan-1970'', ''dd-mon-yyyy''), ' ||
       'null,  ''' ||
       substr(d.name, 1, 3) || ''', ''' ||
       substr(d.name, -4) || ''', ' ||
       '''ND_REPO_EXTRACT_USER'', ''WYBKTO#67UEC1SECN_GUJPNU8BPJ1B'');' "--"
  from v$database d, v$instance v ;

--
-- Extract table information
-- -------------------------------------
select 'insert into ndprobeadmin.track_tables ' ||
       '(dbhost, dbname, dbinstance, version, owner, table_name, track_start, ' ||
       'track_end ) values (''' ||
       v.host_name || ''', ''' ||
       d.name || ''', ''' ||
       v.instance_name || ''', ''' ||
       v.version || ''', ''' ||
       o.owner || ''', ''' ||
       o.object_name || ''', ' ||
       'to_date(''01-Jan-1970'', ''dd-mon-yyyy''), ' ||
       'null ) ;' "--"
  from v$database d, v$instance v, dba_objects o
 where o.object_type in ('TABLE', 'VIEW')
   and upper(o.object_name) in (
        'DATABASE_PROPERTIES',
        'DBA_COL_PRIVS',
        'DBA_DATA_FILES',
        'DBA_DB_LINKS',
        'DBA_OBJECTS',
        'DBA_PROFILES',
        'DBA_ROLES',
        'DBA_ROLE_PRIVS',
        'DBA_SYS_PRIVS',
        'DBA_TABLESPACES',
        'DBA_TAB_PRIVS',
        'DBA_USERS',
        'LOGONAUDITMASK',
        'LOGONAUDITTABLE',
        'V_$DATABASE',
        'V_$INSTANCE',
        'V_$PARAMETER',
        'V_$VERSION')
 order by d.name, o.object_name ;

--
-- Extract column information
-- -------------------------------------
select 'insert into ndprobeadmin.track_columns ' ||
       '(dbhost, dbname, dbinstance, version, owner, table_name, column_name, ' ||
       'track_start, track_end, column_id, data_type, data_length ) ' ||
       'values (''' ||
       v.host_name || ''', ''' ||
       d.name || ''', ''' ||
       v.instance_name || ''', ''' ||
       v.version || ''', ''' ||
       o.owner|| ''', ''' ||
       o.object_name || ''', ''' ||
       c.column_name || ''', ' ||
       'to_date(''01-Jan-1970'', ''dd-mon-yyyy''), ' ||
       'null, ' ||
       c.column_id || ', ''' ||
       c.data_type || ''', ' ||
       c.data_length || ') ;' "--"
  from v$database d, v$instance v, dba_objects o, dba_tab_cols c
 where o.object_type in ('TABLE', 'VIEW')
   and upper(o.object_name) in (
        'DATABASE_PROPERTIES',
        'DBA_COL_PRIVS',
        'DBA_DATA_FILES',
        'DBA_DB_LINKS',
        'DBA_OBJECTS',
        'DBA_PROFILES',
        'DBA_ROLES',
        'DBA_ROLE_PRIVS',
        'DBA_SYS_PRIVS',
        'DBA_TABLESPACES',
        'DBA_TAB_PRIVS',
        'DBA_USERS',
        'LOGONAUDITMASK',
        'LOGONAUDITTABLE',
        'V_$DATABASE',
        'V_$INSTANCE',
        'V_$PARAMETER',
        'V_$VERSION')
   and c.owner = o.owner
   and c.table_name = o.object_name
 order by d.name, o.object_name, c.column_id ;

-- -----------------------------------------------------------------------------
--
-- -----------------------------------------------------------------------------

