-- ---------------------------------------------------------------------
-- File: sql/fix_template.sql
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
select d.name, u.username, u.profile, s.privilege
  from v$database d, dba_sys_privs s, dba_users u
 where u.username = s.grantee
   and u.profile not like 'ND_SYS%'
   and s.privilege like '%DATABASE LINK%'
union
select d.name, r.role, 'Role', s.privilege
  from v$database d, dba_sys_privs s, dba_roles r
 where r.role = s.grantee
   and r.role not in ('DBA', 'RESOURCE', 'IMP_FULL_DATABASE', 'RECOVERY_CATALOG_OWNER', 'ND_ODS_IR_TEAM_S_ROLE')
   and s.privilege like '%DATABASE LINK%';

  v_sql     varchar2(200)   := 0;
  v_mode    varchar2(10)    := '';

--
--
--
  begin
    dbms_output.enable('1000000');
    v_mode := upper('&1');
    
    for r1 in c1 loop
      v_sql := ' revoke ' || r1.privilege || ' from ' || r1.username ;
      
      if v_mode = 'AUTO' then
        execute immediate v_sql;      
      else
        dbms_output.put_line(v_sql || ' ;');
      end if;
    end loop;
  end;
end;
/

exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------
