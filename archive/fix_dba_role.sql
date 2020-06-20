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
   and profile != 'ND_USR_OPEN_DBA'
   and granted_role = 'DBA' ;
  begin
    for r1 in c1 loop

      execute immediate 'revoke dba from ' || r1.username ;
      execute immediate 'grant nd_dba_s_role to ' || r1.username ;
      execute immediate 'grant unlimited tablespace to ' || r1.username ;
    end loop;
  end;
end;
/

exit;
