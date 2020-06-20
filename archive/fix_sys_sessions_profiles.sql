--
--
--
column name             format a10
column profile          format a30
column privilege        format a25
column grantee          format a30
column admin_option     format a15

set serveroutput on
set linesize 300
set pagesize 0
set trimout on
set heading off
set feedback off
--
-- ND_SYS profiles
--   OPEN, unlimited sessions
--   LOCK, 3 sessions
--

BEGIN
  DECLARE
    CURSOR c1
    IS
       SELECT profile,
        resource_name,
        limit
         FROM dba_profiles
        WHERE profile LIKE 'ND_SYS%'
      AND resource_name = 'SESSIONS_PER_USER'
     ORDER BY profile;
    
    v_limit VARCHAR2( 10 ) := '';
    v_sql   VARCHAR2( 99 ) := '';
  BEGIN
    dbms_output.enable(1000000);

    FOR r1 IN c1
    LOOP
      IF r1.profile LIKE 'ND_SYS_OPEN%' THEN
        v_limit := 'unlimited';
      ELSE
        v_limit := '10';
      END IF;
      v_sql := 'alter profile '   || r1.profile || ' limit ' || r1.resource_name || ' ' || v_limit ;
      dbms_output.put_line( v_sql || ' ;' );
      EXECUTE immediate v_sql;
    END LOOP;

    dbms_output.disable;
  END;
END;
/
--
--
--
exit;

