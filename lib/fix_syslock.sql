-- ---------------------------------------------------------------------
-- File: sql/fix_syslock.sql
-- Desc:
--
-- Audit Trail:
-- dd-mon-yyyy  John Grover
--  - Original Code
-- ---------------------------------------------------------------------
ALTER PROFILE ND_SYS_LOCK_ORACLE LIMIT
  SESSIONS_PER_USER         UNLIMITED
  cpu_per_session           default
  cpu_per_call              default
  connect_time              default
  idle_time                 default
  logical_reads_per_session default
  logical_reads_per_call    default
  composite_limit           default
  private_sga               default
  failed_login_attempts     default
  password_life_time        default
  password_reuse_time       default
  password_reuse_max        default
  password_lock_time        default
  password_grace_time       default
  PASSWORD_VERIFY_FUNCTION  ND_PASSWORD_VERIFY ;

exit ;
-- ---------------------------------------------------------------------
--                                             E N D   O F   S C R I P T
-- ---------------------------------------------------------------------

