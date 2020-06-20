--
--
--
begin
  declare
    cursor c1 is
    select name, profile, username, granted_role
      from v$database, dba_users, dba_role_privs
     where username = grantee
       and profile not like 'ND_SYS%'
       and profile != 'DEFAULT'
       and granted_role = 'CONNECT';
  begin
    for r1 in c1 loop
      execute immediate 'grant nd_connect_s_role to ' || r1.username ;
      execute immediate 'revoke connect from ' || r1.username ;
    end loop;
  end;
end;
/

exit;
