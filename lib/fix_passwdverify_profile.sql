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

    cursor c1 is
    select distinct name, profile, resource_name, limit
     from v$database, dba_profiles 
     where profile != 'DEFAULT'
       and resource_name = 'PASSWORD_VERIFY_FUNCTION'
       and limit = 'NULL' ;
   
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
    v_sql(nvl(v_sql.last, 0)+1) := 'alter profile default limit password_verify_function null' ;

-- create the script    
    for r1 in c1 loop
      v_sql(nvl(v_sql.last, 0)+1) := '-- BEFORE: ' || r1.profile || ' limit was ' || r1.limit ;
      v_sql(nvl(v_sql.last, 0)+1) := 'alter profile ' || r1.profile || ' limit PASSWORD_VERIFY_FUNCTION DEFAULT';
    end loop ;
    
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

