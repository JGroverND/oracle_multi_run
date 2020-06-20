-- ---------------------------------------------------------------------
-- File: sql/fix_template.sql
-- Desc: Restore dba's to FULL POWER !
--       ( 'FAHMED', 'JGROVER', 'KBANSAL', 'MCHUA', 'MKULKARN', 'NDOSMANN', 
--         'NELIA', 'TPEREZ1', 'YJIANG1' )
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set serveroutput on
set linesize 512
set trimout on


-- Just in case
alter user FAHMED    profile nd_usr_open_dba account unlock ;
alter user JGROVER   profile nd_usr_open_dba account unlock ;
alter user KBANSAL   profile nd_usr_open_dba account unlock ;
alter user MCHUA     profile nd_usr_open_dba account unlock ;
alter user MKULKARN  profile nd_usr_open_dba account unlock ;
alter user NDOSMANN  profile nd_usr_open_dba account unlock ;
alter user NELIA     profile nd_usr_open_dba account unlock ;
alter user TPEREZ1   profile nd_usr_open_dba account unlock ;
alter user YJIANG1   profile nd_usr_open_dba account unlock ;

-- Restore
grant dba to FAHMED ;
grant dba to JGROVER ;
grant dba to KBANSAL ;
grant dba to MCHUA ;
grant dba to MKULKARN ;
grant dba to NDOSMANN ;
grant dba to NELIA ;
grant dba to TPEREZ1 ;
grant dba to YJIANG1 ;

-- Clean up
begin
  declare cursor c1 is
    select 'revoke ' || granted_role || ' from ' || grantee sqlcode
      from dba_role_privs 
     where grantee in ( 'FAHMED', 'JGROVER', 'KBANSAL', 'MCHUA', 'MKULKARN', 'NDOSMANN', 'NELIA', 'TPEREZ1', 'YJIANG1' )
       and granted_role like 'ND_%'
     UNION
    select 'revoke ' || privilege || ' from ' || grantee
      from dba_sys_privs
     where grantee in ( 'FAHMED', 'JGROVER', 'KBANSAL', 'MCHUA', 'MKULKARN', 'NDOSMANN', 'NELIA', 'TPEREZ1', 'YJIANG1' )
       and privilege <> 'UNLIMITED TABLESPACE'
     UNION
    select 'revoke ' || privilege || ' on ' || owner || '.' || table_name || ' from ' || grantee
      from dba_tab_privs
     where grantee in ( 'FAHMED', 'JGROVER', 'KBANSAL', 'MCHUA', 'MKULKARN', 'NDOSMANN', 'NELIA', 'TPEREZ1', 'YJIANG1' )
       and privilege not in ('READ', 'WRITE');
 
  v_mode varchar2(512);
  
  begin
    dbms_output.enable(1000000);
    v_mode := upper('&1');
    
    for r1 in c1 loop
      dbms_output.put_line(r1.sqlcode || ' ;');
      
      if v_mode = 'AUTO' then
        execute immediate r1.sqlcode ;
      end if;
    end loop;
  end;
end;
/

--
--
--

exit;


