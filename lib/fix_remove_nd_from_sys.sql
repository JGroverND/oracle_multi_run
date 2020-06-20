-- ---------------------------------------------------------------------
-- File: sql/fix_remove_nd_from_sys.sql
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
    select d.name, r.grantee, r.granted_role
      from v$database d, dba_role_privs r
     where r.grantee = 'SYS'
       and r.granted_role like 'ND_%'
     order by 1,2,3 ;
   
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

-- create the script    
    for r1 in c1 loop
      v_sql(nvl(v_sql.last, 0)+1) := 'revoke ' || r1.granted_role || ' from ' || r1.grantee ;
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

