-- ---------------------------------------------------------------------
-- File: sql/fix_unlockedusers.sql
-- Desc:
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
--  - Original Code
--
-- Usage:  sqlplus <user>/<pass>@<database> @fix_unlockedusers [MANUAL|AUTO]
-- ---------------------------------------------------------------------
set serveroutput on

begin
  declare
  cursor c1 is
  select 'alter user ' || username || ' account lock' "sqlcmd"
    from dba_users
   where profile in ('ND_USR_LOCK_DEFAULT', 'ND_USR_LOCK_BUYND') ;
   
  v_sql     varchar2(200)   := 0;
  v_mode    varchar2(10)    := '';
  
--
--
--
  begin
    dbms_output.enable(1000000);
    v_mode := upper('&1');
    
    for r1 in c1 loop
      v_sql := r1.sqlcmd
      
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

