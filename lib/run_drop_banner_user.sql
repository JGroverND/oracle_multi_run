-- ---------------------------------------------------------------------
-- File: sql/run_drop_banner_user.sql
-- Desc:
--
-- Audit Trail:
-- 05-aug-2020  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set pagesize 0
set linesize 512
set trimout on
set heading off
set feedback off
set serveroutput on
set timing off
set verify off

begin
  declare
    type t_sql_code is table of varchar2(256) index by binary_integer ;

    v_sql     t_sql_code ;
    v_idx     number          := 0 ;
    v_enum    number          := 0;
    v_mode    varchar2(10)    := '' ;
    v_name    varchar2(30)    := '' ;
    v_acct    varchar2(30)    := '' ;

    cursor c1 (p_netid sys.dba_users.username%type) is
    select 'a. finance fobprof' as op_type
          ,'delete from fimsmgr.fobprof where fobprof_user_id = ''' || p_netid || '''' as op_sql
      from dual
     where exists (select 1 from fimsmgr.fobprof where fobprof_user_id = p_netid)
    union
    select 'b. finance forusfn' as op_type
          ,'delete from fimsmgr.forusfn where forusfn_user_id_entered = ''' || p_netid || '''' as op_sql
      from dual
     where exists (select 1 from fimsmgr.forusfn where forusfn_user_id_entered = p_netid)
    union
    select 'c. finance forusor' as op_type
          ,'delete from fimsmgr.forusor where forusor_user_id_entered = ''' || p_netid || '''' as op_sql
      from dual
     where exists (select 1 from fimsmgr.forusor where forusor_user_id_entered = p_netid)
    union
    select 'd. finance fzbzfop' as op_type
          ,'delete from ndfiadmin.fzbzfop where fzbzfop_net_id = ''' || p_netid || '''' as op_sql
      from dual
     where exists (select 1 from ndfiadmin.fzbzfop where fzbzfop_net_id = p_netid)
    union
    select 'e. finance zownfop' as op_type
          ,'delete from ndfiadmin.zownfop where zownfop_net_id = ''' || p_netid || '''' as op_sql
      from dual
     where exists (select 1 from ndfiadmin.zownfop where zownfop_net_id = p_netid)
    union
    select 'f. banner class' as op_type
          ,'delete from bansecr.gurucls where gurucls_userid = ''' || p_netid || '''' as op_sql
      from dual
     where exists (select 1 from bansecr.gurucls where gurucls_userid = p_netid)
    union
    select 'g. banner direct' as op_type
          ,'delete from bansecr.guruobj where guruobj_userid = ''' || p_netid || '''' as op_sql
      from dual
     where exists (select 1 from bansecr.guruobj where guruobj_userid = p_netid)
    union
    select 'h. oracle role' as op_type
          ,'revoke ' || granted_role || ' from ' || grantee as op_sql
      from sys.dba_role_privs
     where grantee = p_netid
    union
    select 'i. oracle system' as op_type
          ,'revoke ' || privilege || ' from ' || grantee as op_sql
      from sys.dba_sys_privs
     where grantee = p_netid
    union
    select 'j. oracle table' as op_type
          ,'revoke ' || privilege || ' on ' || owner || '.' || table_name || ' from ' || grantee as op_sql
      from sys.dba_tab_privs
     where grantee = p_netid
    union
    select 'k. oracle column' as op_type
          ,'revoke ' || privilege || ' on ' || owner || '.' ||  table_name || '.' || column_name || ' from ' || grantee as op_sql
      from sys.dba_col_privs
     where grantee = p_netid
    union
    select 'z. oracle user' as op_type
          ,'drop user ' || p_netid || ' cascade' as op_sql
      from dual
     where exists (select 1 from dba_users where username = p_netid)
     order by op_type
;

--
--
-- -------------------------------------
  begin
    v_mode := lower('&1'); -- auto, safe (safe is default)
    v_acct := upper('&2'); -- NetID
    dbms_output.enable(null);

    begin

-- header row for documentation
      select name into v_name from v$database ;
      select count(*) into v_enum from dba_users where username = v_acct ;

-- create the script
      v_sql(nvl(v_sql.last, 0)+1) := '-- Decommissioning ' || v_acct || ' in ' || v_name ;

      for r1 in c1(v_acct) loop
        v_sql(nvl(v_sql.last, 0)+1) := r1.op_sql;

      end loop;

-- execute and/or write the script
      for v_idx in v_sql.first .. v_sql.last loop
        -- if  v_mode = 'auto'
        -- and v_sql.exists(v_idx)
        -- and not regexp_like(v_sql(v_idx), '^--') then
        --   execute immediate v_sql(v_idx) ;
        -- end if ;

        dbms_output.put_line( v_sql(v_idx) || ' ;' ) ;
      end loop ;
    end;
  end ;
end ;
/

exit ;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------
