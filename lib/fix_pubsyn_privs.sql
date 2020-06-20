-- ---------------------------------------------------------------------
-- File: sql/fix_pubsyn_privs.sql
-- Desc:
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
begin
  declare
  cursor c1 is
  select d.name
    from v$database,
   where 
   order by 
   
  v_sql     varchar2(200)   := 0;
  v_mode    varchar2(10)    := '';
  
--
--
--
  begin
    v_mode := upper(&1);
    
    for r1 in c1 loop
      v_sql := 
      
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
