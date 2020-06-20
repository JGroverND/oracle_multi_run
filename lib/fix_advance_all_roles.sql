-- ---------------------------------------------------------------------
-- File: sql/fix_advance_all_roles.sql
-- Desc: Make sure nd_advance_all_q_role, nd_advance_all_u_role, nd_advance_all_x_role,
--                 nd_advance_admin_all_q_role,nd_advance_admin_all_u_role, and
--                 nd_advance_admin_all_x_role have all the necessary grants.
--
-- Usage sqlplus username/password @fix_advance_all_roles [auto|manual]
--   - auto will execute the grants and produce an output file containing the sql used
--   - manual will only produce the output sql file containing the grants.
--
-- Audit Trail:
-- 01-Jun-2009  John Grover
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

    cursor c_owners is
    select username as owner
      from dba_users
     where profile like 'ND_OWN%'
     order by 1;

    cursor c_objects (p_owner varchar2) is
    select owner, object_type, object_name
      from dba_objects
     where owner = p_owner
     order by 1, 2, 3;

    cursor c_roles (p_owner varchar2) is
    select role
      from dba_roles
     where regexp_like(role, '^ND_' || upper(p_owner) || '_ALL_[QSX]_ROLE$')
     order by 1;

    v_sql     t_sql_code ;

    v_idx     number          := 0 ;
    v_q_cnt   number          := 0 ;
    v_u_cnt   number          := 0 ;
    v_x_cnt   number          := 0 ;

    v_mode    varchar2(10)    := '' ;
    v_name    varchar2(30)    := '' ;
    v_grant   varchar2(30)    := '' ;

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
    for r_owner in c_owners loop
      for r_object in c_objects(r_owner.owner) loop
        for r_role in c_roles(r_owner.owner) loop
          v_grant := 'no';

            select count(*) into v_q_cnt
              from dba_tab_privs
             where owner      = r_object.owner
               and table_name = r_object.object_name
               and grantee    = r_role.role
               and privilege  = 'SELECT';

            select count(*) into v_u_cnt
              from dba_tab_privs
             where owner      = r_object.owner
               and table_name = r_object.object_name
               and grantee    = r_role.role
               and privilege  in ('SELECT', 'UPDATE', 'INSERT', 'DELETE');

            select count(*) into v_x_cnt
              from dba_tab_privs
             where owner      = r_object.owner
               and table_name = r_object.object_name
               and grantee    = r_role.role
               and privilege  = 'EXECUTE';

          if regexp_like(r_role.role, '_Q_ROLE$') and 
             r_object.object_type in ('TABLE', 'VIEW', 'SEQUENCE') and
             v_q_cnt < 1 then
            v_grant := 'select';
          end if;

          if regexp_like(r_role.role, '_U_ROLE$') and 
             r_object.object_type in ('TABLE', 'VIEW') and
             v_u_cnt < 4 then
            v_grant := 'select, update, insert, delete';
          end if;

          if regexp_like(r_role.role, '_X_ROLE$') and 
             r_object.object_type in ('FUNCTION', 'PACKAGE', 'PROCEDURE') and
             v_x_cnt < 1 then
            v_grant := 'execute';
          end if;

          if v_grant != 'no' then
            v_sql(nvl(v_sql.last, 0)+1) := 'grant ' || v_grant || ' on ' || 
                                           r_object.owner || '.' || 
                                           r_object.object_name || ' to ' || 
                                           r_role.role;
          end if;
        end loop;
      end loop;
    end loop;

-- execute and/or write the script    
    for v_idx in v_sql.first .. v_sql.last loop
      if  v_mode = 'auto' 
      and v_sql.exists(v_idx) 
      and not regexp_like(v_sql(v_idx), '^--') then
        begin
          execute immediate v_sql(v_idx) ;
        exception
          when others then null;
        end;
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

