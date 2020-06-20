-- ---------------------------------------------------------------------
-- File: sql/fix_usrpriv2role.sql
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

    cursor c_s(p_grantee varchar2) is
    select privilege
      from dba_sys_privs
     where grantee = p_grantee
       and privilege <> 'UNLIMITED TABLESPACE'
       and admin_option = 'NO' ;
       
    cursor c_q(p_grantee varchar2) is
    select privilege, owner, table_name, grantee
      from dba_tab_privs
     where grantee = p_grantee
       and privilege = 'SELECT'
       and grantable = 'NO' ;

    cursor c_u(p_grantee varchar2) is
    select privilege, owner, table_name, grantee
      from dba_tab_privs
     where grantee = p_grantee
       and privilege in ('INSERT', 'UPDATE', 'DELETE')
       and grantable = 'NO' ;

    cursor c_x(p_grantee varchar2) is
    select privilege, owner, table_name, grantee
      from dba_tab_privs
     where grantee = p_grantee
       and privilege = 'EXECUTE'
       and grantable = 'NO' ;
   
    v_sql     t_sql_code ;  
    v_cnt     number          := 0 ;    
    v_idx     number          := 0 ;
    v_mode    varchar2(10)    := '' ;
    v_user    varchar2(30)    := '' ;    
    v_name    varchar2(30)    := '' ;
  
--
-- 
-- -------------------------------------
  begin
    v_mode := lower('&1');
    v_user := lower('&2');
    dbms_output.enable(1000000);

-- header row for documentation    
    select name into v_name from v$database ;
    v_sql(nvl(v_sql.last, 0)+1) := '-- ##### Begin ' || v_name || ' in ' || v_mode || 
                                   ' mode for ' || v_user || ' ##### --' ;

-- create the script 
-- System privileges
    select count(*) into v_cnt 
      from dba_sys_privs 
     where grantee = upper(v_user) 
       and privilege <> 'UNLIMITED TABLESPACE'
       and admin_option = 'NO' ;

    if v_cnt > 0 then
      v_sql(nvl(v_sql.last, 0)+1) := '-- -------------------------------------' ;
      v_sql(nvl(v_sql.last, 0)+1) := 'create role nd_usr_' || v_user || '_s_role' ;
      v_sql(nvl(v_sql.last, 0)+1) := 'grant nd_usr_' || v_user || '_s_role to ' || v_user ;
            
      for r_s in c_s(upper(v_user)) loop
        v_sql(nvl(v_sql.last, 0)+1) := 'grant  ' || r_s.privilege || ' to   nd_usr_' || v_user || '_s_role' ;
        v_sql(nvl(v_sql.last, 0)+1) := 'revoke ' || r_s.privilege || ' from ' || v_user ;
      end loop ;
    end if;

-- Select privileges    
    select count(*) into v_cnt 
      from dba_tab_privs 
     where grantee = upper(v_user) 
       and privilege = 'SELECT' 
       and grantable = 'NO' ;

    if v_cnt > 0 then
      v_sql(nvl(v_sql.last, 0)+1) := '-- -------------------------------------' ;
      v_sql(nvl(v_sql.last, 0)+1) := 'create role nd_usr_' || v_user || '_q_role' ;
      v_sql(nvl(v_sql.last, 0)+1) := 'grant nd_usr_' || v_user || '_q_role to ' || v_user ;
            
      for r_q in c_q(upper(v_user)) loop
        v_sql(nvl(v_sql.last, 0)+1) := 'grant  ' || r_q.privilege || 
                                       ' on ' || r_q.owner || '.' || r_q.table_name || 
                                       ' to   nd_usr_' || v_user || '_q_role' ;
        v_sql(nvl(v_sql.last, 0)+1) := 'revoke ' ||  r_q.privilege || 
                                       ' on ' || r_q.owner || '.' || r_q.table_name || 
                                       ' from ' || v_user ;
      end loop ;
    end if;

-- Update privileges    
    select count(*) into v_cnt 
      from dba_tab_privs 
     where grantee = upper(v_user) 
       and privilege in ('INSERT', 'UPDATE', 'DELETE')
       and grantable = 'NO' ;

    if v_cnt > 0 then
      v_sql(nvl(v_sql.last, 0)+1) := '-- -------------------------------------' ;
      v_sql(nvl(v_sql.last, 0)+1) := 'create role nd_usr_' || v_user || '_u_role' ;
      v_sql(nvl(v_sql.last, 0)+1) := 'grant nd_usr_' || v_user || '_u_role to ' || v_user ;
            
      for r_u in c_u(upper(v_user)) loop
        v_sql(nvl(v_sql.last, 0)+1) := 'grant select, ' || r_u.privilege || 
                                       ' on ' || r_u.owner || '.' || r_u.table_name || 
                                       ' to   nd_usr_' || v_user || '_q_role' ;
        v_sql(nvl(v_sql.last, 0)+1) := 'revoke        ' ||  r_u.privilege || 
                                       ' on ' || r_u.owner || '.' || r_u.table_name || 
                                       ' from ' || v_user ;
      end loop ;
    end if;

-- Execute privileges    
    select count(*) into v_cnt 
      from dba_tab_privs 
     where grantee = upper(v_user) 
       and privilege = 'EXECUTE'
       and grantable = 'NO' ;

    if v_cnt > 0 then
      v_sql(nvl(v_sql.last, 0)+1) := '-- -------------------------------------' ;
      v_sql(nvl(v_sql.last, 0)+1) := 'create role nd_usr_' || v_user || '_x_role' ;
      v_sql(nvl(v_sql.last, 0)+1) := 'grant nd_usr_' || v_user || '_x_role to ' || v_user ;
            
      for r_x in c_x(upper(v_user)) loop
        v_sql(nvl(v_sql.last, 0)+1) := 'grant  ' || r_x.privilege || 
                                       ' on ' || r_x.owner || '.' || r_x.table_name || 
                                       ' to   nd_usr_' || v_user || '_q_role' ;
        v_sql(nvl(v_sql.last, 0)+1) := 'revoke ' ||  r_x.privilege || 
                                       ' on ' || r_x.owner || '.' || r_x.table_name || 
                                       ' from ' || v_user ;
      end loop ;
    end if;

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

