--
-- Replace direct grant of create session with nd_connect_s_role for all non-sys accounts
-- ( no net change in privileges )
--
BEGIN
  DECLARE
    CURSOR c1
    IS
       SELECT username, profile, admin_option
         FROM dba_sys_privs, dba_users
        WHERE privilege = 'CREATE SESSION'
      and username = grantee
      AND ( profile not like 'ND_SYS%' and profile != 'DEFAULT' )
      and admin_option = 'NO'
     ORDER BY profile;
    
    v_sql   VARCHAR2( 99 ) := '';
    v_mode  varchar2( 99 ) := '';
  BEGIN
    v_mode := upper('&1')
    dbms_output.enable(1000000);

    FOR r1 IN c1
    LOOP

      v_sql := 'grant nd_connect_s_role to ' || r1.username ;
      dbms_output.put_line( v_sql || ' ;' );
      
      if v_mode = 'AUTO' then
        EXECUTE immediate v_sql;
      end if;

      v_sql := 'revoke create session from ' || r1.username ;
      dbms_output.put_line( v_sql || ' ;' );
      
      if v_mode = 'AUTO' then
        EXECUTE immediate v_sql;
      end if;
    END LOOP;
  END;
END;
/
--
--
--
exit;

