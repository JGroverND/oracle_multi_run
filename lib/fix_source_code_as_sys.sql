-- ---------------------------------------------------------------------
-- File: sql/fix_source_code_as_sys.sql
-- Desc:
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set serveroutput on
set linesize 512
set trimout on
set verify off
set showmode off

begin
  declare
    type t_sql_code is table of varchar2(256) index by binary_integer ;

    cursor c1 is
select name, grantee, privilege
  from v$database, dba_sys_privs 
 where privilege in (
       'CREATE ANY PROCEDURE',
       'ALTER ANY PROCEDURE',
       'EXECUTE ANY PROCEDURE',
       'ALTER ANY TRIGGER',
       'CREATE ANY TRIGGER')
   and grantee not in (
       'ABSSOLUTE',
       'BAN_DEFAULT_M',
       'BANINST1',
       'BUSOBJ_USER',
       'DBA',
       'DBSNMP',
       'EDWMGR',
       'EDWSTG',
       'EXFSYS',
       'EXP_FULL_DATABASE',
       'IA_ADMIN',
       'IMP_FULL_DATABASE',
       'INTRCONFIG',
       'MDSYS',
       'ND_ADV_APPADMIN_S_ROLE',
       'ND_ADV_APPSUPPORT_S_ROLE',
       'ND_ADV_PHONE_BATCH_S_ROLE',
       'ND_ADV_REPORT_TEA_S_ROLE',
       'ND_BAN_IR_TEAM_S_ROLE',
       'ND_BAN_REPORTING_TEAM_S_ROLE',
       'ND_BAN_USR_GSASECR_S_ROLE',
       'ND_BOUSER_LINK',
       'ND_DBA_S_ROLE',
       'NDFIADMIN',
       'ND_GSASECR_S_ROLE',
       'NDHRPYADMIN',
       'NDIDCARDADMIN',
       'ND_IR_TEAM_ROLE',
       'ND_ODS_ADMIN',
       'ND_REPO_ADMIN',
       'ND_REPORTING_TEAM_ROLE',
       'ND_REPORTING_TEAM_S_ROLE',
       'NDSTMGR',
       'NDTALISMAADMIN',
       'ND_USR_TOAD_S_ROLE',
       'ND_WHSE',
       'ND_WHSE_LINK',
       'NDWORKFLOWADMIN',
       'ODSMGR',
       'OUTLN',
       'OWBRT_SYS',
       'OWNER50RMS',
       'RMSLOGIN',
       'RMSREAL',
       'SYS',
       'TEADMIN',
       'TIMESERIES_DBA',
       'USR_GSASECR',
       'USR_GSASECR_BANSECR_VMELODY',
       'WFAUTO',
       'WFQUERY',
       'WKSYS',
       'WMSYS',
       'XDB')
 order by privilege, grantee;
    
    v_sql     t_sql_code ;  
    v_idx     number          := 0 ;
    v_mode    varchar2(10)    := '' ;
    v_name    varchar2(30)    := '' ;
  
--
-- 
-- -------------------------------------
  begin
    v_mode := lower('&1');
    dbms_output.enable(1000000);

-- header row for documentation    
    select name into v_name from v$database ;
    v_sql(nvl(v_sql.last, 0)+1) := '--##### Begin ' || v_name || ' in ' || v_mode || ' mode #####--' ;

-- create the script    
    for r1 in c1 loop
      v_sql(nvl(v_sql.last, 0)+1) := 'revoke ' || r1.privilege || ' from ' || r1.grantee || ' ; --' || r1.name ;
    end loop ;
    
-- execute and/or write the script    
    for v_idx in v_sql.first .. v_sql.last loop
      if  v_mode = 'auto' 
      and v_sql.exists(v_idx) 
      and not regexp_like(v_sql(v_idx), '^--') then
        execute immediate v_sql(v_idx) ;
      end if ;

      dbms_output.put_line( v_sql(v_idx) || ' ;' ) ;
    end loop ;
  end ;
end ;
/

exit ;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

