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

--
--
--
column  name            format a10
column  database        format a10
column  username        format a30
column  grantee         format a30
column  role            format a30
column  granted_role    format a30
column  profile         format a30
column  privilege       format a22
column  param           format a30
column  value           format a30

begin
  declare
    type t_sql_code is table of varchar2(256) index by binary_integer ;

    v_sql     t_sql_code ;
    v_idx     number          := 0 ;
    v_enum    number          := 0;
    v_mode    varchar2(10)    := '' ;
    v_name    varchar2(30)    := '' ;
    v_acct    varchar2(30)    := '' ;

    cursor c1 is
    select 'role' as op_type
          ,granted_role as op_privilege
          ,grantee as op_grantee
      from sys.dba_role_privs
     where grantee = upper(&2)
     union
    select 'system' as op_type
           ,PRIVILEGE as as op_privilege
           || grantee as op_grantee
      from sys.dba_sys_privs
     where grantee = upper(&2)
    union
    select 'table'
          ,PRIVILEGE || on || OWNER || '.' || TABLE_NAME as op_privilege
          ,grantee as op_grantee
      from sys.dba_tab_privs
     where grantee = upper(&2)
    union
    select 'column' as op_type
          ,PRIVILEGE || ' on ' || OWNER || '.' ||  TABLE_NAME || '.' || COLUMN_NAME as op_privilege
          ,grantee  as op_grantee
      from sys.dba_col_privs
     where grantee = upper(&2);
--
--
-- -------------------------------------
  begin
    v_mode := lower('&1');
    v_acct := upper('&2');
    dbms_output.enable(null);

    begin

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

--
--
--

--
--
--
end;
/

exit ;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------
-- -------------------------------------
-- USER: Revoke all (Banner)
-- -------------------------------------


-- ----------------------------------------------------------
select 'delete from fimsmgr.FOBPROF where FOBPROF_USER_ID = '''
       || upper(:NETID)
       || ''';'
  from dual
  where EXISTS (SELECT 1 from fimsmgr.FOBPROF where FOBPROF_USER_ID = upper(:NETID))
union
-- ----------------------------------------------------------
select 'delete from fimsmgr.FORUSFN where FORUSFN_USER_ID_ENTERED = '''
       || upper(:NETID)
       || ''';'
  from dual
  where EXISTS (SELECT 1 from fimsmgr.FORUSFN where FORUSFN_USER_ID_ENTERED = upper(:NETID))
union
-- ----------------------------------------------------------
select 'delete from fimsmgr.FORUSOR where FORUSOR_USER_ID_ENTERED = '''
       || upper(:NETID)
       || ''';'
  from dual
  where EXISTS (SELECT 1 from fimsmgr.FORUSOR where FORUSOR_USER_ID_ENTERED = upper(:NETID))
union
-- ----------------------------------------------------------
select 'delete from ndfiadmin.fzbzfop where FZBZFOP_NET_ID = '''
       || upper(:NETID)
       || ''';'
  from dual
  where EXISTS (SELECT 1 from ndfiadmin.fzbzfop where FZBZFOP_NET_ID = upper(:NETID))
union
-- ----------------------------------------------------------
select 'delete from ndfiadmin.zownfop where ZOWNFOP_NET_ID = '''
       || upper(:NETID)
       || ''';'
  from dual
  where EXISTS (SELECT 1 from ndfiadmin.zownfop where ZOWNFOP_NET_ID = upper(:NETID))
union
-- ----------------------------------------------------------
select 'delete from bansecr.gurucls where gurucls_userid = '''
       || upper(:NETID)
       || ''';'
  from dual
    where exists (select 1 from bansecr.gurucls where gurucls_userid=upper(:NETID))

union
select 'delete from bansecr.guruobj where guruobj_userid = '''
       || upper(:NETID)
       || ''';'
  from dual
    where exists (select 1 from bansecr.guruobj where guruobj_userid=upper(:NETID))
union
select 'drop user '
       || upper(:NETID)
       || 'cascade  ;'
  from dual
  where exists (select 1 from dba_users where username=upper(:NETID))
union
select 'commit;'
from dual
 order by 1 desc
-- End
