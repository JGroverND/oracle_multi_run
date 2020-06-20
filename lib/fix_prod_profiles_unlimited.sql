-- ---------------------------------------------------------------------
-- File: sql/fix_default_profile.sql
-- Desc:
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
set serveroutput on
set lines 512
set trimout on
ALTER PROFILE DEFAULT LIMIT
  SESSIONS_PER_USER         1
  cpu_per_session           unlimited
  cpu_per_call              unlimited
  CONNECT_TIME              15
  IDLE_TIME                 5
  logical_reads_per_session unlimited
  logical_reads_per_call    unlimited
  composite_limit           unlimited
  private_sga               unlimited
  FAILED_LOGIN_ATTEMPTS     10
  password_life_time        7
  password_reuse_time       unlimited
  password_reuse_max        unlimited
  password_lock_time        .01
  PASSWORD_GRACE_TIME       0
  password_verify_function  null ;

exit;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

