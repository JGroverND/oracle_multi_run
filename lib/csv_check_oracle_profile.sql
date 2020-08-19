-- ---------------------------------------------------------------------
-- File: sql/check_oracle_profiler.sql
-- Desc:
--
-- Audit Trail:
-- 17-aug-2020  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set serveroutput on
set linesize 170
set pagesize 0
set trimout on
set verify off
set showmode off
set markup csv on
--
--
--
column database         format a8
column username         format a30
column created          format a16
column last_login       format a16
column days_ago         format 9,999
column proposed_profile format a30
column current_profile  format a30
column account_status   format a4
column sys              format a3
column usr              format a3
column lnk              format a3
column own              format a3
column pwr              format a3

with
-- *************************************
-- PEOPLE have a USR profile
-- -------------------------------------
people as (
select username acct
  from dba_users
 where profile like 'ND_USR%'
 order by username
),
-- *************************************
-- OWNERS own objects
-- -------------------------------------
owners as (
select distinct owner acct
  from dba_objects
 order by owner
),
-- *************************************
-- LINK users are only identified by profile (receive a DB Link)
-- -------------------------------------
link_users as (
select username acct
  from dba_users
 where profile = 'ND_LNK_OPEN_DEFAULT'
),
-- *************************************
-- Oracle SYS users are identifed in dba_users
-- -------------------------------------
sys_users as (
select username acct
  from dba_users
 where oracle_maintained = 'Y'
),
-- *************************************
-- Developers have "extra" roles assigned
-- -------------------------------------
developers as (
select distinct grantee acct
  from dba_role_privs
  join dba_users on ((username = grantee) and (profile like 'ND_USR%'))
 where granted_role like 'ND%'
   and granted_role not in ('ND_CONNECT_S_ROLE', 'ND_RESOURCE_S_ROLE')
)
-- =============================================================================
-- MAIN query body
-- =============================================================================
select d.name database
      ,dba_users.username username
      ,to_char(dba_users.created, 'YYYY-MM-DD HH:mm') created
      ,to_char(dba_users.last_login, 'YYYY-MM-DD HH:mm') last_login
      ,nvl(round(sysdate - cast(dba_users.last_login as date),2), 0) days_ago
      ,
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> --
-- rule-base profile determination: copy me to the WHERE clause if you change me!
-- -----------------------------------------------------------------------------
'ND_' ||                                                                      -- ----- PREFIX
--                                                                            -- ----- TYPE (SYS, USR, LNK, OWN, APP)
case when (sys_users.acct is not null)        then 'SYS_' else                -- account is an Oracle account
  case when (people.acct is not null)         then 'USR_' else                -- account is a person
    case when (owners.acct is not null)       then 'OWN_' else                -- account owns objects
      case when (link_users.acct is not null) then 'LNK_' else                -- account receives a DB Link
        'APP_'                                                                -- account is an application account
end end end end ||                                                            --
--                                                                            -- ----- STATUS (OPEN, LOCK)
case when ((sys_users.acct is not null) and                                   -- open oracle built-in accounts set as open
           (decode(dba_users.account_status, 'OPEN', 'OPEN', 'LOCK') = 'OPEN'))--
       or (link_users.acct is not null)                                       -- open link accounts
       or (people.acct is not null)                                           -- open user accounts
     then 'OPEN_'                                                             --
     else decode(account_status, 'OPEN', 'OPEN_', 'LOCK_')                    -- everything else is based on account status
end ||                                                                        --
--                                                                            -- ----- USER_TYPE (ORACLE,POWERUSER,DEFAULT)
case when (sys_users.acct is not null)                  then 'ORACLE'    else -- account is an Oracle account
  case when (developers.acct is not null)               then 'POWERUSER' else -- account is POWER_USER
    'DEFAULT'                                                                 -- account is DEFAULT type
end end                                                                       --
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< --
       proposed_profile
      ,profile current_profile
      ,decode(account_status, 'OPEN', 'OPEN', 'LOCK') account_status
      ,case when (sys_users.acct is null)       then null else 'Y' end sys
      ,case when (people.acct is null)          then null else 'Y' end usr
      ,case when (link_users.acct is null)      then null else 'Y' end lnk
      ,case when (owners.acct is null)          then null else 'Y' end own
      ,case when (developers.acct is null)      then null else 'Y' end pwr
  from dba_users
  join v$database d on 1=1
  left outer join people            on (people.acct          = dba_users.username)
  left outer join owners            on (owners.acct          = dba_users.username)
  left outer join sys_users         on (sys_users.acct       = dba_users.username)
  left outer join link_users        on (link_users.acct      = dba_users.username)
  left outer join developers        on (developers.acct      = dba_users.username)
-- -----------------------------------------------------------------------------
-- WHERE clause filters
-- -----------------------------------------------------------------------------
 where (
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> --
-- rule-base profile determination: copy me to the WHERE clause if you change me!
-- -----------------------------------------------------------------------------
'ND_' ||                                                                      -- ----- PREFIX
--                                                                            -- ----- TYPE (SYS, USR, LNK, OWN, APP)
case when (sys_users.acct is not null)        then 'SYS_' else                -- account is an Oracle account
  case when (people.acct is not null)         then 'USR_' else                -- account is a person
    case when (owners.acct is not null)       then 'OWN_' else                -- account owns objects
      case when (link_users.acct is not null) then 'LNK_' else                -- account receives a DB Link
        'APP_'                                                                -- account is an application account
end end end end ||                                                            --
--                                                                            -- ----- STATUS (OPEN, LOCK)
case when ((sys_users.acct is not null) and                                   -- open oracle built-in accounts set as open
           (decode(account_status, 'OPEN', 'OPEN', 'LOCK') = 'OPEN'))         --
       or (link_users.acct is not null)                                       -- open link accounts
       or (people.acct is not null)                                           -- open user accounts
     then 'OPEN_'                                                             --
     else decode(account_status, 'OPEN', 'OPEN_', 'LOCK_')                    -- everything else is based on account status
end ||                                                                        --
--                                                                            -- ----- USER_TYPE (ORACLE,POWERUSER,DEFAULT)
case when (sys_users.acct is not null)                  then 'ORACLE'    else -- account is an Oracle account
  case when (developers.acct is not null)               then 'POWERUSER' else -- account is POWER_USER
    'DEFAULT'                                                                 -- account is DEFAULT type
end end                                 --
-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< --
        ) != dba_users.profile
 order by proposed_profile, username
;
