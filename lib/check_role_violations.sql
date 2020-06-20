-- ---------------------------------------------------------------------
-- File: check_role_violations.sql
-- Desc: Show violations of grants of DBA, RESOURCE, and ND_DBA_S_ROLE
--
-- Audit Trail:
-- 02-Mar-2010 jgrover
--  - Original code
-- ---------------------------------------------------------------------
set pagesize 0
set linesize 300
set trimout on
set heading off
set feedback off
set serveroutput on
--
--
--
column  name            format a10
column  database        format a10
column  username        format a30
column  grantee         format a30
column  role            format a30
column  granted_role    format a30
column  profile         format a30
column  privilege       format a22
column  default_role    format a3
column  value           format a30

select a.name ||'|'|| 
       d.granted_role ||'|'|| 
       u.profile ||'|'|| 
       u.username ||'|'|| 
       u.account_status ||'|'|| 
       d.default_role
  from dba_role_privs d, dba_users u, v$database a
 where ( u.username = d.grantee )
   and (
         -- Eliminate documented exceptions for DBA role
         ( d.granted_role = 'DBA' and
           lower(u.username) not in('csmig','gridman','sys','sysman','system',  
                                    'fahmed','jgrover','kbansal','mchua',   
                                    'mkulkarn','ndosmann','nelia','yjiang1')
         )
         or
         -- Eliminate documented exceptions for RESOURCE role
         ( d.granted_role = 'RESOURCE' and             
           lower(u.username) not in ('csmig','ctxsys','exfsys','mddata','mdsys',
                                     'olapsys','outln','owbrt_sys','oem_monitor', 
                                     'sys','tsmsys','wksys','wmsys','xdb',
                                     'logstdby_operator','olap_user')
         )
         or
         -- Elimiate documented exceptions for ND_DBA_S_ROLE
         ( d.granted_role = 'ND_DBA_S_ROLE' and
           lower(u.username) not in ('advance','abssolute','abssystem','vpxadmin',
                                     'busobj_user','ia_admin','twilson2','bosscars',
                                     'bansso','bansecr','bosssec','sa',     
                                     'nd_dbprotect_user')
          )
        )  ;
--
--
--

exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

