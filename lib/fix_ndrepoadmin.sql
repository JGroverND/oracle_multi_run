-- ---------------------------------------------------------------------
-- File: sql/fix_template.sql
-- Desc:
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set serveroutput on
set linesize 512
set trimout on
set verify off
set showmode off

begin
  declare
    type t_sql_code is table of varchar2(256) index by binary_integer ;
   
    v_sql     t_sql_code ;  
    v_idx     number          := 0 ;
    v_mode    varchar2(10)    := '' ;
    v_name    varchar2(30)    := '' ;
  
--
-- 
-- -------------------------------------
  begin
    v_mode := lower('&1');
    dbms_output.enable(1000000);
    
-- header row for documentation    
    select name into v_name from v$database ;
    v_sql(nvl(v_sql.last, 0)+1) := '--##### Begin ' || v_name || ' in ' || v_mode || ' mode #####--' ;
    
--  v_sql(nvl(v_sql.last, 0)+1) := 
--    'CREATE SMALLFILE TABLESPACE NDREPOADMIN ' ||
--    'DATAFILE ''/u03/oradata/' || v_name || '/ndrepoadmin_01.dbf'' ' ||
--    'SIZE 512M AUTOEXTEND ON NEXT 56M MAXSIZE 31000M LOGGING ' ||
--    'EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO' ;
--
--  v_sql(nvl(v_sql.last, 0)+1) := 
--    'CREATE USER ndrepoadmin IDENTIFIED BY values ''!'' profile nd_own_lock_default ' ||
--    'DEFAULT TABLESPACE NDREPOADMIN TEMPORARY TABLESPACE temp ACCOUNT lock password expire' ;
      
    v_sql(nvl(v_sql.last, 0)+1) := 'GRANT nd_connect_s_role  TO ndrepoadmin' ;
    v_sql(nvl(v_sql.last, 0)+1) := 'GRANT nd_resource_s_role TO ndrepoadmin' ;
    v_sql(nvl(v_sql.last, 0)+1) := 'GRANT unlimited tablespace TO ndrepoadmin' ;

    
-- execute and/or write the script    
    for v_idx in v_sql.first .. v_sql.last loop
      if  v_mode = 'auto' 
      and v_sql.exists(v_idx) 
      and not regexp_like(v_sql(v_idx), '^--') then
        execute immediate v_sql(v_idx) ;
      end if ;

      dbms_output.put_line( v_sql(v_idx) || ' ;' ) ;
    end loop ;
  end ;
end ;
/

exit ;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

