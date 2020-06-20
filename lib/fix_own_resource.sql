-- ---------------------------------------------------------------------
-- File: sql/fix_own_resource.sql
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
  select username
    from dba_users
   where profile like 'ND_OWN%';

  cursor c2 is
  select d.name, r.grantee, r.granted_role
    from v$database d, dba_role_privs r
   where r.granted_role = 'ND_RESOURCE_S_ROLE'
   order by r.grantee;
   
  v_sql     varchar2(200)   := '';
  v_sql2    varchar2(200)   := '';
  v_mode    varchar2(10)    := '';
  
--
--
--
  begin
    v_mode := upper('&1');
    dbms_output.enable(1000000);

--
-- 1. ND_RESOURCE_S_ROLE should contain
--    CREATE PROCEDURE
--    CREATE SEQUENCE
--    CREATE SESSION
--    CREATE SYNONYM
--    CREATE TABLE
--    CREATE TRIGGER
--    CREATE VIEW
-- Adding ...
--    CREATE PUBLIC SYNONYM
--
    if v_mode = 'AUTO' then
      execute immediate 'grant CREATE PROCEDURE to ND_RESOURCE_S_ROLE';
      execute immediate 'grant CREATE SEQUENCE to ND_RESOURCE_S_ROLE';
      execute immediate 'grant CREATE SESSION to ND_RESOURCE_S_ROLE';
      execute immediate 'grant CREATE SYNONYM to ND_RESOURCE_S_ROLE';
      execute immediate 'grant CREATE TABLE to ND_RESOURCE_S_ROLE';
      execute immediate 'grant CREATE TRIGGER to ND_RESOURCE_S_ROLE';
      execute immediate 'grant CREATE VIEW to ND_RESOURCE_S_ROLE';
      execute immediate 'grant CREATE PUBLIC SYNONYM to ND_RESOURCE_S_ROLE';
    else
      dbms_output.put_line('grant CREATE PROCEDURE to ND_RESOURCE_S_ROLE ;');
      dbms_output.put_line('grant CREATE SEQUENCE to ND_RESOURCE_S_ROLE ;');
      dbms_output.put_line('grant CREATE SESSION to ND_RESOURCE_S_ROLE ;');
      dbms_output.put_line('grant CREATE SYNONYM to ND_RESOURCE_S_ROLE ;');
      dbms_output.put_line('grant CREATE TABLE to ND_RESOURCE_S_ROLE ;');
      dbms_output.put_line('grant CREATE TRIGGER to ND_RESOURCE_S_ROLE ;');
      dbms_output.put_line('grant CREATE VIEW to ND_RESOURCE_S_ROLE ;');
      dbms_output.put_line('grant CREATE PUBLIC SYNONYM to ND_RESOURCE_S_ROLE ;');
    end if;
--
-- 1. All owner accounts get nd_resource_s_role
--
    for r1 in c1 loop
      if v_mode = 'AUTO' then
        execute immediate 'grant nd_resource_s_role to ' || r1.username ;
        execute immediate 'revoke CREATE PROCEDURE from ' || r1.username ;
        execute immediate 'revoke CREATE SEQUENCE from ' || r1.username ;
        execute immediate 'revoke CREATE SESSION from ' || r1.username ;
        execute immediate 'revoke CREATE SYNONYM from ' || r1.username ;
        execute immediate 'revoke CREATE TABLE from ' || r1.username ;
        execute immediate 'revoke CREATE TRIGGER from ' || r1.username ;
        execute immediate 'revoke CREATE VIEW from ' || r1.username ;
        execute immediate 'revoke CREATE PUBLIC SYNONYM from ' || r1.username ;
      else
        dbms_output.put_line('grant nd_resource_s_role to ' || r1.username || ' ;');
        dbms_output.put_line('revoke CREATE PROCEDURE from ' || r1.username || ' ;');
        dbms_output.put_line('revoke CREATE SEQUENCE from ' || r1.username || ' ;');
        dbms_output.put_line('revoke CREATE SESSION from ' || r1.username || ' ;');
        dbms_output.put_line('revoke CREATE SYNONYM from ' || r1.username || ' ;');
        dbms_output.put_line('revoke CREATE TABLE from ' || r1.username || ' ;');
        dbms_output.put_line('revoke CREATE TRIGGER from ' || r1.username || ' ;');
        dbms_output.put_line('revoke CREATE VIEW from ' || r1.username || ' ;');
        dbms_output.put_line('revoke CREATE PUBLIC SYNONYM from ' || r1.username || ' ;');
      end if;
    end loop;    
--
-- 2. No grantees of ND_RESOURCE_S_ROLE get RESOURCE
--    All grantees of nd_resource_s_role get unlimited tablespace
--
    for r2 in c2 loop
      if v_mode = 'AUTO' then
        execute immediate 'revoke resource from ' || r2.grantee ;
        execute immediate 'grant unlimited tablespace to ' || r2.grantee ;
      else
        dbms_output.put_line('revoke resource from ' || r2.grantee || ' ;');
        dbms_output.put_line('grant unlimited tablespace to ' || r2.grantee || ' ;');
      end if;
    end loop;
  end;
end;
/

exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------
