-- ---------------------------------------------------------------------
-- File: sql/template_auto_safe.sql
-- Desc:
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
--  - Original Code
--
-- Usage:  sqlplus <user>/<pass>@<database> @<sql_file> [auto|safe]
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
    select d.name
      from v$database,
     where
     order by

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
      v_sql(nvl(v_sql.last, 0)+1) := '-- create your SQL here'
    end loop ;

-- execute and/or print the script
    for v_idx in v_sql.first .. v_sql.last loop
      dbms_output.put_line( v_sql(v_idx) || ' ;' ) ;
      if  v_mode = 'auto'
      and v_sql.exists(v_idx)
      and not regexp_like(v_sql(v_idx), '^--') then
        execute immediate v_sql(v_idx) ;
      end if ;
    end loop ;
  end ;
end ;
/

exit ;
