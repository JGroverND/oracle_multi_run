-- ---------------------------------------------------------------------
-- File: sql/fix_resource_privs.sql
-- Desc:
-- Replace direct grants of privs in nd_resource_s_role with the role
-- ( Accounts that have one or more of these privs will get the entire role )
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
   -- any privilege in the nd_resource_s_role
    cursor c1 is
       select u.username, u.profile, s.privilege, s.admin_option
         from dba_sys_privs s, dba_users u
        where s.privilege in (select s2.privilege from dba_sys_privs s2 where grantee = 'ND_RESOURCE_S_ROLE')
          and username = grantee
          and ( profile not like 'ND_SYS%' and profile != 'DEFAULT' )
          and privilege <> 'CREATE SESSION'
          and admin_option = 'NO'
        order by u.profile, u.username;

    v_idx       number         := 0 ;
    v_mode      varchar2( 10 ) := null ;
    v_name      varchar2( 30 ) := null ;
    v_last_user varchar2( 30 ) := '0' ;
    v_curr_user varchar2( 30 ) := null ;
    v_execute   t_sql_code ;    
  begin
    dbms_output.enable(1000000);
    
    v_mode := lower('&1');
    
    select name into v_name from v$database ;
    
    v_execute(nvl(v_execute.last, 0)+1) := '--##### Begin ' || v_name || ' in ' || v_mode || ' mode #####--' ;

    for r1 in c1 loop
    -- r1 will be empty after end loop
      v_curr_user := r1.username ;     

      -- break on username
      if r1.username != v_last_user then
        -- wrap up previous user
        if v_last_user <> '0' then
          v_execute(nvl(v_execute.last, 0)+1) := 'grant nd_resource_s_role to ' || v_last_user ;
          v_execute(nvl(v_execute.last, 0)+1) := 'grant unlimited tablespace to ' || v_last_user ;
        end if ;

        -- begin new user
        v_last_user := r1.username ;
        v_execute(nvl(v_execute.last, 0)+1) := '-- begin user ' || v_last_user ;
      end if;

      -- revoke individual privileges
      v_execute(nvl(v_execute.last, 0)+1) := 'revoke ' || r1.privilege || ' from ' || r1.username ;
    end loop ;

    -- wrap up last user
    if v_curr_user is not null then
      v_execute(nvl(v_execute.last, 0)+1) := 'grant nd_resource_s_role to ' || v_curr_user ;        
      v_execute(nvl(v_execute.last, 0)+1) := 'grant unlimited tablespace to ' || v_curr_user ;
    end if ;

    v_execute(nvl(v_execute.last, 0)+1) := '--#####  End ' || v_name || ' in ' || v_mode || ' mode #####--' ;

    -- execute or write the script    
    for v_idx in v_execute.first .. v_execute.last loop
      if v_mode = 'auto' and v_execute.exists(v_idx) and not regexp_like(v_execute(v_idx), '^--') then
        execute immediate v_execute(v_idx) ;
      end if ;

      dbms_output.put_line( v_execute(v_idx) || ' ;' ) ;
    end loop ;
  end ;
end ;
/

exit ;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

