-- ---------------------------------------------------------------------
-- File: sql/fix_nd_s_role_ut.sql
-- Desc:
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set serveroutput on

begin
  declare
  cursor c1 is
  select d.name, r.granted_role, r.grantee, u.profile
    from v$database d, dba_role_privs r, dba_users u
   where r.granted_role in ('ND_DBA_S_ROLE', 'ND_RESOURCE_S_ROLE', 'DBA', 'RESOURCE')
     and u.username = r.grantee
     and username != 'SYS'
     and not exists ( select 1 from dba_sys_privs s where s.privilege = 'UNLIMITED TABLESPACE' and s.grantee = r.grantee ) ;
        
  v_sql     varchar2(200)   := 0;
  v_mode    varchar2(10)    := '';
  
--
--
--
  begin
    v_mode := upper('&1');
    
    dbms_output.enable('1000000');
    
    for r1 in c1 loop
      v_sql := 'grant unlimited tablespace to ' || r1.grantee ;
      
      if v_mode = 'AUTO' then
        execute immediate v_sql ;      
      end if;
      dbms_output.put_line(v_sql || ' ;');
    end loop;
  end;
end;
/

exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------
