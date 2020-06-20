-- ---------------------------------------------------------------------
-- File: sql/check_nd_s_rolee.sql
-- Desc:
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set pagesize 0
set linesize 300
set trimout on
set heading off
set feedback off

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
column  param           format a30
column  value           format a30

--
--
--
  select d.name||','||r.granted_role||','||u.profile ||','||u.username||','||c.objs "-- data"
    from v$database d, 
         dba_role_privs r, 
         dba_users u, 
         ( select o.owner, count(*) objs 
             from dba_objects o 
            where o.object_type <> 'SYNONYM'
            group by o.owner ) c
   where r.granted_role = 'ND_RESOURCE_S_ROLE'
     and u.username = r.grantee
     and c.owner = u.username
     and u. profile not like 'ND_OWN%' 
     and c.objs < 1 
UNION
  select d.name||','||r.granted_role||','||u.profile ||','||u.username||',NA' "-- data"
    from v$database d, dba_role_privs r, dba_users u
   where r.grantee = u.username
     and r.granted_role = 'ND_DBA_S_ROLE'
     and r.grantee not in ('Exception List Here',
                         'ADVANCE','ABSSOLUTE','ABSSYSTEM','VPXADMIN','BUSOBJ_USER',
                         'IA_ADMIN','TWILSON2','BOSSCARS','BANSSO','BANSECR','BOSSSEC',
                         'ND_DBPROTEC_USER') 
/
 
 exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

