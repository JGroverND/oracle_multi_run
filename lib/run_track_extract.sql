-- -----------------------------------------------------------------------------
-- File: track_extract.sql
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
--
--

select '-- ' || name || ' ----------------------------------------' "--"
  from v$database;

--
-- I. Expire current meta data
--
-- I. a. expire database meta data
-- -------------------------------------
select 'update ndprobeadmin.track_databases set track_end = sysdate where dbhost=''' || v.host_name || 
       ''' and dbname=''' || d.name || 
       ''';' "--"
  from v$database d, v$instance v ;
--
-- I. b. expire table metadata
--
select 'update ndprobeadmin.track_tables set track_end = sysdate where dbhost=''' || v.host_name || 
       ''' and dbname=''' || d.name || 
       ''';' "--"
  from v$database d, v$instance v ;
--
-- I. c. expire column meta data
--
select 'update ndprobeadmin.track_columns set track_end = sysdate where dbhost=''' || v.host_name || 
       ''' and dbname=''' || d.name || 
       ''';' "--"
  from v$database d, v$instance v ;

--
-- II. Extract database meta data
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
-- III. Extract table meta data
-- -------------------------------------
select 'insert into ndprobeadmin.track_tables ' ||
       '(dbhost, dbname, dbinstance, version, owner, table_name, load_method, track_start, ' ||
       'track_end ) values (''' ||
       v.host_name || ''', ''' ||
       d.name || ''', ''' ||
       v.instance_name || ''', ''' ||
       v.version || ''', ''' ||
       o.owner || ''', ''' ||
       o.object_name || ''', ' ||
       '''COMPARE'', ' ||
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
      	'DBA_TABLES',
	      'DBA_INDEXES',
        'LOGONAUDITMASK',
        'LOGONAUDITTABLE',
        'V_$DATABASE',
        'V_$INSTANCE',
        'V_$PARAMETER',
        'V_$VERSION',
        'GV_$ACTIVE_INSTANCES',
        'GV_$INSTANCE',
        'DBA_JOBS',
        'GV_$SERVICES',
        'DBA_SERVICES',
	      'DB_BACKUPS',
        'GV_$ACTIVE_SERVICES',
	      'TOP50_LOBS',
	      'TOP50_TABLES',
	      'TOP50_INDEXES',
        'DBA_REGISTRY',
        'DBA_REGISTRY_HISTORY')
 order by d.name, o.object_name ;

--
-- IV. Extract column  meta data
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
       case
         when regexp_like(c.data_type, 'TIMESTAMP*') then 'TIMESTAMP'
         else c.data_type end  || ''', ' ||
       case
         when regexp_like(c.data_type, 'TIMESTAMP*') then 6
         else c.data_length end || ') ;' "--"
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
      	'DBA_TABLES',
	      'DBA_INDEXES',
        'LOGONAUDITMASK',
        'LOGONAUDITTABLE',
        'V_$DATABASE',
        'V_$INSTANCE',
        'V_$PARAMETER',
        'V_$VERSION',
        'GV_$ACTIVE_INSTANCES',
        'GV_$INSTANCE',
        'DBA_JOBS',
        'GV_$SERVICES',
        'DBA_SERVICES',
	      'DB_BACKUPS',
        'GV_$ACTIVE_SERVICES',
        'DBA_TABLESPACES',
	      'TOP50_LOBS',
	      'TOP50_TABLES',
	      'TOP50_INDEXES',
        'DBA_REGISTRY',
        'DBA_REGISTRY_HISTORY')
   and c.owner = o.owner
   and c.table_name = o.object_name
 order by d.name, o.object_name, c.column_id ;

-- -----------------------------------------------------------------------------
-- 
-- -----------------------------------------------------------------------------

