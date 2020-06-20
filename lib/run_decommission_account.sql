-- ---------------------------------------------------------------------
-- File: run_decommission_account.sql
-- Desc: drop or lock account using OMR framework
--
-- Audit Trail:
-- 21-Nov-2012  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set serveroutput on
set linesize 512
set trimout on
set verify off
set showmode off
set feedback off
begin
  declare
    type t_sql_code is table of varchar2(256) index by binary_integer ;

    v_sql     t_sql_code ;
    v_idx     number          := 0 ;
    v_enum    number          := 0;
    v_mode    varchar2(10)    := '' ;
    v_name    varchar2(30)    := '' ;
    v_acct    varchar2(30)    := '' ;

--
--
-- -------------------------------------
  begin
    v_mode := lower('&1');
    v_acct := upper('&2');
    dbms_output.enable(null);

-- header row for documentation
    select name into v_name from v$database ;
    select count(*) into v_enum from dba_users where username = v_acct ;
    
-- create the script
    if (v_enum > 0)
    then
      v_sql(nvl(v_sql.last, 0)+1) := '-- Decommissioning ' || v_acct || ' in ' || v_name ;

      if (v_name like 'BNR%')
      then
        v_sql(nvl(v_sql.last, 0)+1) := 'alter user ' || v_acct || ' identified by values ''!'' account lock password expire' ;

      else
        v_sql(nvl(v_sql.last, 0)+1) := 'drop user ' || v_acct || ' cascade ' ;

      end if ;
      
    else
      v_sql(nvl(v_sql.last, 0)+1) := '-- No account ' || v_acct || ' in ' || v_name ;

    end if ;

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

