-- ---------------------------------------------------------------------
-- File: sql/fix_resource_s_ut.sql
-- Desc:
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set pagesize 0
set linesize 300
set trimout on
set heading off
set feedback off
set serveroutput on
begin
  declare
  cursor c1 is
  select d.name, 
         u.username, 
         u.profile, 
         r.granted_role
    from v$database d,
         dba_role_privs r,
         dba_users u
   where r.grantee = u.username
     and r.granted_role  = 'ND_RESOURCE_S_ROLE'
     and not exists ( 
         select 1 
           from dba_sys_privs s 
          where s.privilege = 'UNLIMITED TABLESPACE' 
            and s.grantee = r.grantee )
   order by u.profile, u.username ;
   
  v_sql     varchar2(200)   := 0;
  v_mode    varchar2(10)    := '';
  
--
--
--
  begin
    dbms_output.enable(1000000);
    
    v_mode := upper('&1');

    for r1 in c1 loop
      v_sql := 'grant unlimited tablespace to ' || r1.username ;
      
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
-- -----------------------------------------------------------------------

