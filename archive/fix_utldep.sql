--
-- MUST RUN AS SYSDBA
--
begin
  declare
    cursor c1 is
    select distinct 'grant execute on ' || p.referenced_owner || '.' || p.referenced_name || ' to ' || p.owner "sqlcmd"
      from dba_dependencies p
     where p.referenced_owner = 'SYS'
       and p.referenced_name in ('UTL_FILE', 'UTL_SMTP', 'UTL_HTTP', 'UTL_TCP')
       and p.owner not in ('SYS', 'PUBLIC') ;
  begin
    for r1 in c1 loop
      -- dbms_output.put_line(r1."sqlcmd");
      execute immediate r1."sqlcmd";
    end loop;
    
    execute immediate 'grant  execute on UTL_FILE to   oracle_ocm' ;
    execute immediate 'revoke execute on UTL_FILE from public' ;
    execute immediate 'revoke execute on UTL_SMTP from public' ;
    execute immediate 'revoke execute on UTL_HTTP from public' ;
    execute immediate 'revoke execute on UTL_TCP  from public' ;
  end;
end;
/

exit;

