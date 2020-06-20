-- ---------------------------------------------------------------------
-- File: sql/fix_system_ts.sql
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
select d.name, 
       u.username, 
       u.profile, 
       (select count(*) 
          from dba_tables 
         where owner = u.username 
           and tablespace_name = 'SYSTEM') tables, 
       (select count(*) 
          from dba_indexes 
         where owner = u.username 
           and tablespace_name = 'SYSTEM') indices
  from v$database d, 
       dba_users u
 where default_tablespace = 'SYSTEM' ;

  v_sql     varchar2(200)   := 0 ;
  v_mode    varchar2(10)    := '' ;

--
--
--
  begin
    dbms_output.enable(1000000);
    v_mode := upper('&1') ;

    for r1 in c1 loop
      if r1.tables = 0 and r1.indices = 0 then
        v_sql := 'alter user ' || r1.username || ' default tablespace users' ;

        if v_mode = 'AUTO' then
          execute immediate v_sql;      
        else
          dbms_output.put_line(v_sql || ' ;');
        end if;
      end if;
    end loop;
  end;
end;
/

exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------
