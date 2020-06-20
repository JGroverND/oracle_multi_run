--
--
--
set serveroutput on

begin
  declare
  cursor c1 is
  select username, granted_role, profile
    from dba_role_privs, dba_users
   where granted_role in ('CONNECT', 'RESOURCE', 'DBA')
     and username = grantee
     and profile not like 'ND_SYS%' 
     and profile != 'DEFAULT';
    
  begin
    for r1 in c1 loop
      execute immediate 'grant nd_' || r1.granted_role || '_s_role to ' || r1.username ;
      execute immediate 'revoke ' || r1.granted_role || ' from ' || r1.username ;
    end loop;
  end;
end;
/
exit;

