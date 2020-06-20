set serveroutput on

begin
declare
 cursor c1 is
 select 'AUDIT ' || name sqlcmd
   from system_privilege_map
  where name like '%ANY%'
     or name like '%EXEMPT%'
     or name like '%UNLIMITED%'
     or name like '%GRANT%'
     or ( name like '%CREATE%' and name != 'CREATE SESSION' )
     or name like '%DROP%'
     or name like '%ALTER%'
     or name like '%BECOME%'
 order by name ;

 v_cnt number := 0 ;

 begin
   dbms_output.enable (1000000) ;

   for r1 in c1 loop
     begin
       execute immediate r1.sqlcmd ;
       v_cnt := v_cnt + 1 ;

     exception
       when others then
         dbms_output.put_line(SQLERRM || r1.sqlcmd || ' FAILED') ;
     end ;
   end loop ;

   dbms_output.put_line( v_cnt || ' audit statements processed') ;

 end ;
end ;
/

exit

