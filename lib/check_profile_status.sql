-- ---------------------------------------------------------------------
-- File: sql/check_nondefault_profiles.sql
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
column  limit           format a10
column  database        format a10
column  resource_name   format a30
column  username        format a30
column  grantee         format a30
column  role            format a30
column  granted_role    format a30
column  profile         format a30
column  privilege       format a22
column  param           format a30
column  value           format a30
--
-- Custom check for DbProtect
--
select d.name, u.username, u.account_status, u.profile, nvl(c.objcnt, 0)
  from v$database d, 
       dba_users u,  
       ( select owner, count(*) objcnt
           from dba_objects o
          where o.object_type != 'SYNONYM' 
          group by owner ) c
 where c.owner(+) = u.username
   and ( ( u.profile like '%LOCK%' and              -- lock?
           u.account_status not like '%LOCK%' ) OR  --
         ( u.profile like '%OPEN%' and                -- open?
           u.account_status not like '%OPEN%' ) OR    --
         ( u.profile like '%OWN%'  and              -- non-owner?
           nvl(c.objcnt, 0) < 1 ) OR                --
         ( u.profile not like '%OWN%' and             -- owner?
           u.profile not like '%SYS%' and             --
           u.profile != 'ND_USR_OPEN_DBA' and         --
           nvl(c.objcnt, 0) > 0 ) )                   --
   and ( d.name || u.username not in ('Exception List Here') )
/

