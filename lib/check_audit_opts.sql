--
--
--

set pagesize 0
set linesize 300
set trimout on
set heading off
set feedback off
set serveroutput on

select name from v$database;
  
select count(*) || ' Audit Rows' from sys.aud$ ;

select * from dba_stmt_audit_opts;

select name, s.* from v$database, dba_priv_audit_opts s ;

select name, s.owner, s.object_type, s.object_name, count(*)
  from v$database, dba_obj_audit_opts s 
 group by name, s.owner, s.object_type, s.object_name
 order by name, s.owner, s.object_type, s.object_name ;

