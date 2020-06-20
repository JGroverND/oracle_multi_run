-- ---------------------------------------------------------------------
-- File: sql/fix_lock_and_expire.sql
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

    cursor c1 ( p_username varchar2 ) is
    select d.name, u.username, u.password
      from v$database d, dba_users u
     where username = p_username ;
   
    v_sql     t_sql_code ;  
    v_idx     number          := 0 ;
    v_mode    varchar2(10)    := '' ;
    v_name    varchar2(30)    := '' ;
    v_user    varchar2(30)    := '' ;
  
--
-- 
-- -------------------------------------
  begin
    v_mode := lower('&1') ;
    v_user := upper('&2') ;
    dbms_output.enable(1000000) ;

-- header row for documentation    
    select name into v_name from v$database ;
    v_sql(nvl(v_sql.last, 0)+1) := '--##### Begin ' || v_name || ' in ' || v_mode || ' mode #####--' ;

-- create the script    
    for r1 in c1 ( v_user ) loop
      v_sql(nvl(v_sql.last, 0)+1) := 'alter user ' || r1.username || 
                                     ' identified by values ''!'' account lock password expire' ;
      v_sql(nvl(v_sql.last, 0)+1) := '-- alter user ' || r1.username || 
                                     ' identified by values ' || r1.password || 
                                     ' account lock password expire' ;
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

