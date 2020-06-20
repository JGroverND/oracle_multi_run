-- ---------------------------------------------------------------------
-- File: sql/fix_invalidsynonyms.sql
-- Desc: Rebuild or remove synonyms invalidated when their target object
--       is dropped and recreated. If the target exists the synonyms is 
--       rebuilt, if the the target is gone the synonym is dropped.
--
-- Audit Trail:
-- 13-Apr-2009  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set linesize 300
set pagesize 0
set trimout on
set feedback off
set verify off
set serveroutput on

BEGIN
--
-- List of all invalid synonyms
-- -------------------------------------
  declare cursor c1 is
  select o.status syn_stat, 
         o.object_type obj_type, 
         s.owner syn_owner, 
         s.synonym_name syn_name, 
         s.table_owner tgt_own, 
         s.table_name tgt_name
    from dba_objects o,
         dba_synonyms s
   where o.object_type  = 'SYNONYM' 
     and o.status       = 'INVALID'
     and s.owner        = o.owner
     and s.synonym_name = o.object_name ;
     
  type t_sql_code is table of varchar2(256) index by binary_integer ;
  v_sql           t_sql_code ; 
  
  v_mode          varchar2(20) ;
  v_name          varchar2(256) ;
  v_make          varchar2(256) ;
  v_cnt           number := 0 ;
  v_cntdrop       number := 0 ;
  v_cntmake       number := 0;

  BEGIN
    dbms_output.enable(null);
    v_mode := lower('&1') ;

-- header row for documentation    
    select name into v_name from v$database ;
    v_sql(nvl(v_sql.last, 0)+1) := 
      '-- ##### Begin ' || v_name || 
      ' in ' || v_mode || 
      ' mode ##### --' ;

    for r1 in c1 loop
--
-- drop each invalid public synonym
-- -------------------------------------
      v_cntdrop := v_cntdrop + 1 ;
      
      if r1.syn_owner = 'PUBLIC' then
        v_sql(nvl(v_sql.last, 0)+1) := 
          'drop   public synonym ' || r1.syn_name ;
      else
        v_sql(nvl(v_sql.last, 0)+1) := 
          'drop   synonym ' || r1.syn_owner || '.' || r1.syn_name ;
      end if ;
      
--
-- re-create if the target object exists
-- -------------------------------------
      select count(*) into v_cnt 
        from dba_objects 
       where owner = r1.tgt_own 
         and object_name = r1.tgt_name ;

      if v_cnt > 0 then
        v_cntmake := v_cntmake + 1 ;
        v_make := ' for ' || r1.tgt_own || '.' ||  r1.tgt_name ;

        if r1.syn_owner = 'PUBLIC' then
          v_sql(nvl(v_sql.last, 0)+1)   := '  create public synonym ' || r1.syn_name || v_make ;
        else
          v_sql(nvl(v_sql.last, 0)+1)   := '  create synonym ' || r1.syn_owner || 
                                           '.'|| r1.syn_name || v_make ;
        end if ;
      else
        v_sql(nvl(v_sql.last, 0)+1)     := 
          '  --     Missing target ' || r1.tgt_own || '.' ||  r1.tgt_name ||
          ' for synonym ' || r1.syn_owner || '.'|| r1.syn_name;
      end if ;
    end loop ;

    for v_idx in v_sql.first .. v_sql.last loop
      if  v_mode = 'auto' 
      and v_sql.exists(v_idx) 
      and not regexp_like(v_sql(v_idx), '^--') then
        execute immediate v_sql(v_idx) ;
      end if ;

      dbms_output.put_line( v_sql(v_idx) || ' ;' ) ;
    end loop ;

    dbms_output.put_line('-- -------------------------------------') ;
    dbms_output.put_line('-- synonym validation complete.') ;
    dbms_output.put_line('-- synonyms dropped: ' || v_cntdrop ) ;
    dbms_output.put_line('-- synonyms created: ' || v_cntmake ) ;
    dbms_output.put_line('-- -------------------------------------') ;
  END ;
END ;
/

exit;

