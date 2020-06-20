-- ---------------------------------------------------------------------
-- File: sql/fix_unlimited_priv.sql
-- Desc:
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
begin
  declare
  cursor c1 is
  select d.name, 
         u.username, 
         u.profile, 
         s.privilege
    from v$database d,
         dba_sys_privs s,
         dba_users u
   where s.privilege = 'UNLIMITED TABLESPACE'
     and u.username = s.grantee
     and u.profile not like 'ND_SYS%'
     and u.profile not like 'ND_OWN%'
     and u.profile != 'ND_USER_OPEN_DBA'
   order by u.profile, u.username ;
   
  v_sql     varchar2(200)   := 0;
  v_mode    varchar2(10)    := '';
  
--
--
--
  begin
    v_mode := upper(&1);
    
    for r1 in c1 loop
      v_sql := 'revoke ' || r1.privilege || ' from ' || r1.username ;
      
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

