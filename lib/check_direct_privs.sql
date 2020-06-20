-- ---------------------------------------------------------------------
-- File: sql/check_direct_privs.sql
-- Desc:
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set serveroutput on

begin
  declare

--
-- User list
-- -------------------------------------
  cursor c1 is
  select username, profile
    from dba_users
   where profile like 'ND_USR%'
     and profile <> 'ND_USR_OPEN_DBA'
   order by profile, username ;

--
-- Privileges per user
-- -------------------------------------
  cursor c2 ( p_grantee varchar2 ) is
  select name || ', ' ||
         'Role' || ', ' ||
         GRANTEE || ', ' ||
         '?'  || ', ' ||
         GRANTED_ROLE || decode(DEFAULT_ROLE, 'YES', '*', null) || ', ' ||
         '?' || ', ' ||
         ADMIN_OPTION || ', ' ||
         '?' as c_priv_desc
    from v$database d, dba_role_privs
   where grantee = upper(p_grantee)
     and granted_role not in ('BAN_DEFAULT_CONNECT', 'BAN_DEFAULT_M', 'BAN_DEFAULT_Q', 'ND_CONNECT_S_ROLE')
  union
  -- -------------------------------------
--  select ' Database: ' || name  ||
--         ' Account: '  || username ||
--         ' Profile: '  || profile || 
--         ' Account Status: ' || account_status
--    from v$database d, dba_users
--   where username = upper(p_grantee)
--  union
  -- -------------------------------------
  select name  || ', ' ||
         'Ownership'  || ', ' ||
         owner || ', ' ||
         object_type  || ', ' ||
         to_char(count(*))  || ', ' ||
         '?' || ', ' ||
         '?' || ', ' ||
         '?'
    from v$database d, dba_objects
   where owner = upper(p_grantee)
    group by name, owner, object_type
  union
  -- -------------------------------------
  select name  || ', ' ||
         'System'  || ', ' ||
         GRANTEE  || ', ' ||
         '?' || ', ' ||
         PRIVILEGE  || ', ' ||
         ADMIN_OPTION  || ', ' ||
         '?' || ', ' ||
         '?' 
    from v$database d, dba_sys_privs
   where grantee = upper(p_grantee)
  union
  -- -------------------------------------
  select name  || ', ' ||
         'Table'  || ', ' ||
         GRANTEE  || ', ' ||
         OWNER  || '.' || TABLE_NAME  || ', ' ||
         PRIVILEGE  || ', ' ||
         GRANTABLE  || ', ' ||
         GRANTOR  || ', ' ||
         '?' 
    from v$database d, dba_tab_privs
   where grantee = upper(p_grantee)
  union
  -- -------------------------------------
  select name   || ', ' ||
         'Col Priv'  || ', ' ||
         GRANTEE  || ', ' ||
         OWNER  || '.' ||
         TABLE_NAME||'.'||COLUMN_NAME  || ', ' ||
         PRIVILEGE  || ', ' ||
         GRANTABLE  || ', ' ||
         GRANTOR  || ', ' ||
         '?'
    from v$database d, dba_col_privs
   where grantee = upper(p_grantee) ;

  v_user_count    number := 0;
-- ---------------------------------------------------------------------
-- 
-- ---------------------------------------------------------------------
  begin
--
--
-- -------------------------------------
    dbms_output.enable (9999999) ;
    dbms_output.put_line('Database, Priv Type, Grantee, Object, Privilege/Role, Grantable, Grantor, Default');
  
    <<outer_loop>>
    for r1 in c1 loop
      v_user_count := v_user_count + 1;
      exit outer_loop when v_user_count > 1000;

      dbms_output.put_line(r1.username);
      for r2 in c2( r1.username ) loop
        dbms_output.put_line(r2.c_priv_desc);
      end loop;
    end loop;
  end;
end;
/
exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

