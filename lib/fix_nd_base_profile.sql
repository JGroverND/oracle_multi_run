-- ---------------------------------------------------------------------
--
-- File: nd_base_profiles.sql
-- Desc: Base profile definitions, all databases will have these profiles
--
-- Requires ND_LOGONAUDIT_ADMIN.ND_PASS_UTIL  (nd_password_utility.pkg, nd_password_utility.pkb)
-- Requires sys.nd_password_verify functions  (nd_password_verify_sys.sql)
--
-- Explanation of values:
--  SESSIONS_PER_USER         Session Count
--  CPU_PER_SESSION           Minutes
--  CPU_PER_CALL              Minutes
--  CONNECT_TIME              Minutes
--  IDLE_TIME                 Minutes
--  LOGICAL_READS_PER_SESSION Number of Reads
--  LOGICAL_READS_PER_CALL    Number of Reads
--  COMPOSITE_LIMIT           Number of Reads
--  PRIVATE_SGA               Bytes
--  FAILED_LOGIN_ATTEMPTS     Login count
--  PASSWORD_LIFE_TIME        Days
--  PASSWORD_REUSE_TIME       Days
--  PASSWORD_REUSE_MAX        Reuse count
--  PASSWORD_LOCK_TIME        Days          .01 = approx. 15 min.
--  PASSWORD_GRACE_TIME       Days          how many days prior to expiration user is warned
--  PASSWORD_VERIFY_FUNCTION  Database function ;
--
-- ND Password verify functions:
--   nd_password_verify     30 character
--   nd_password_verify_sys 30 character
--   nd_password_verify_app 16 character
--   nd_password_verify_usr 8  character
--
-- 11-Nov-2008
--   Lastest Draft
-- Fri Mar 13 11:24:02 2009 John Grover 
--   Another round of tweaks
--
-- ---------------------------------------------------------------------

--
-- Default is very restrictive, it is not intended to be used
-- -------------------------------------
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
  password_verify_function  NULL ;
--
-- Special temporary profile
-- -------------------------------------
ALTER PROFILE ND_TMP_UNLIMITED LIMIT
  SESSIONS_PER_USER         UNLIMITED
  cpu_per_session           default
  cpu_per_call              default
  CONNECT_TIME              UNLIMITED
  IDLE_TIME                 UNLIMITED
  logical_reads_per_session default
  logical_reads_per_call    default
  composite_limit           default
  private_sga               default
  failed_login_attempts     default
  PASSWORD_LIFE_TIME        UNLIMITED
  password_reuse_time       default
  password_reuse_max        default
  password_lock_time        default
  PASSWORD_GRACE_TIME       14
  password_verify_function  default ;

-- ---------------------------------------------------------------------
-- OPEN Profiles
-- ---------------------------------------------------------------------
ALTER PROFILE ND_APP_OPEN_DEFAULT LIMIT
  SESSIONS_PER_USER         UNLIMITED
  cpu_per_session           default
  cpu_per_call              default
  CONNECT_TIME              UNLIMITED
  IDLE_TIME                 UNLIMITED
  logical_reads_per_session default
  logical_reads_per_call    default
  composite_limit           default
  private_sga               default
  failed_login_attempts     default
  PASSWORD_LIFE_TIME        unlimited
  password_reuse_time       default
  password_reuse_max        default
  password_lock_time        default
  PASSWORD_GRACE_TIME       14
  PASSWORD_VERIFY_FUNCTION  default ;

ALTER PROFILE ND_LNK_OPEN_DEFAULT LIMIT
  SESSIONS_PER_USER         UNLIMITED
  cpu_per_session           default
  cpu_per_call              default
  CONNECT_TIME              UNLIMITED
  IDLE_TIME                 UNLIMITED
  logical_reads_per_session default
  logical_reads_per_call    default
  composite_limit           default
  private_sga               default
  failed_login_attempts     default
  PASSWORD_LIFE_TIME        UNLIMITED
  password_reuse_time       default
  password_reuse_max        default
  password_lock_time        default
  PASSWORD_GRACE_TIME       14
  PASSWORD_VERIFY_FUNCTION  default ;

ALTER PROFILE ND_SYS_OPEN_ORACLE LIMIT
  SESSIONS_PER_USER         UNLIMITED
  cpu_per_session           default
  cpu_per_call              default
  CONNECT_TIME              UNLIMITED
  IDLE_TIME                 UNLIMITED
  logical_reads_per_session default
  logical_reads_per_call    default
  composite_limit           default
  private_sga               default
  failed_login_attempts     default 
  PASSWORD_LIFE_TIME        UNLIMITED
  password_reuse_time       default
  password_reuse_max        default
  password_lock_time        default
  PASSWORD_GRACE_TIME       14
  PASSWORD_VERIFY_FUNCTION  default ;

ALTER PROFILE ND_SYS_OPEN_OPERATIONS LIMIT
  SESSIONS_PER_USER         UNLIMITED
  cpu_per_session           default
  cpu_per_call              default
  CONNECT_TIME              UNLIMITED
  IDLE_TIME                 UNLIMITED
  logical_reads_per_session default
  logical_reads_per_call    default
  composite_limit           default
  private_sga               default
  failed_login_attempts     default 
  PASSWORD_LIFE_TIME        UNLIMITED
  password_reuse_time       default
  password_reuse_max        default
  password_lock_time        default
  PASSWORD_GRACE_TIME       14
  PASSWORD_VERIFY_FUNCTION  default ;

ALTER PROFILE ND_OWN_OPEN_DEFAULT LIMIT
  SESSIONS_PER_USER         UNLIMITED
  cpu_per_session           default
  cpu_per_call              default
  CONNECT_TIME              UNLIMITED
  IDLE_TIME                 UNLIMITED
  logical_reads_per_session default
  logical_reads_per_call    default
  composite_limit           default
  private_sga               default
  failed_login_attempts     default 
  PASSWORD_LIFE_TIME        UNLIMITED
  password_reuse_time       default
  password_reuse_max        default
  password_lock_time        default
  PASSWORD_GRACE_TIME       14
  PASSWORD_VERIFY_FUNCTION  default ;

ALTER PROFILE ND_USR_OPEN_DEFAULT LIMIT
  SESSIONS_PER_USER         default
  cpu_per_session           default
  cpu_per_call              default
  CONNECT_TIME              720
  IDLE_TIME                 240
  logical_reads_per_session default
  logical_reads_per_call    default
  composite_limit           default
  private_sga               default
  failed_login_attempts     default 
  PASSWORD_LIFE_TIME        UNLIMITED
  password_reuse_time       default
  password_reuse_max        default
  password_lock_time        default
  PASSWORD_GRACE_TIME       14
  PASSWORD_VERIFY_FUNCTION  default ;

ALTER PROFILE ND_USR_OPEN_DBA LIMIT
  SESSIONS_PER_USER         UNLIMITED
  cpu_per_session           default
  cpu_per_call              default
  CONNECT_TIME              720
  IDLE_TIME                 240
  logical_reads_per_session default
  logical_reads_per_call    default
  composite_limit           default
  private_sga               default
  failed_login_attempts     default 
  PASSWORD_LIFE_TIME        180
  password_reuse_time       default
  password_reuse_max        default
  password_lock_time        default
  PASSWORD_GRACE_TIME       14
  PASSWORD_VERIFY_FUNCTION  default ;

ALTER PROFILE ND_USR_OPEN_DEVELOPER LIMIT
  SESSIONS_PER_USER         10
  cpu_per_session           default
  cpu_per_call              default
  CONNECT_TIME              720
  IDLE_TIME                 240
  logical_reads_per_session default
  logical_reads_per_call    default
  composite_limit           default
  private_sga               default
  failed_login_attempts     default 
  PASSWORD_LIFE_TIME        UNLIMITED
  password_reuse_time       default
  password_reuse_max        default
  password_lock_time        default
  PASSWORD_GRACE_TIME       14
  PASSWORD_VERIFY_FUNCTION  default ;

ALTER PROFILE ND_USR_OPEN_POWERUSER LIMIT
  SESSIONS_PER_USER         10
  cpu_per_session           default
  cpu_per_call              default
  CONNECT_TIME              720
  IDLE_TIME                 240
  logical_reads_per_session default
  logical_reads_per_call    default
  composite_limit           default
  private_sga               default
  failed_login_attempts     default 
  PASSWORD_LIFE_TIME        UNLIMITED
  password_reuse_time       default
  password_reuse_max        default
  password_lock_time        default
  PASSWORD_GRACE_TIME       14
  PASSWORD_VERIFY_FUNCTION  default ;

-- ---------------------------------------------------------------------
-- LOCKED Profiles
-- ---------------------------------------------------------------------
ALTER PROFILE ND_APP_LOCK_DEFAULT LIMIT
  sessions_per_user         default
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
  PASSWORD_VERIFY_FUNCTION  default ;

ALTER PROFILE ND_OWN_LOCK_DEFAULT LIMIT
  sessions_per_user         default
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
  PASSWORD_VERIFY_FUNCTION  default ;

ALTER PROFILE ND_SYS_LOCK_ORACLE LIMIT
  SESSIONS_PER_USER         UNLIMITED
  cpu_per_session           default
  cpu_per_call              default
  CONNECT_TIME              UNLIMITED
  IDLE_TIME                 UNLIMITED
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
  PASSWORD_VERIFY_FUNCTION  default ;

--
-- These accounts should never log into the databse
-- -------------------------------------
ALTER PROFILE ND_USR_LOCK_DEFAULT LIMIT
  SESSIONS_PER_USER         default
  CPU_PER_SESSION           default
  CPU_PER_CALL              default
  CONNECT_TIME              default
  IDLE_TIME                 default
  LOGICAL_READS_PER_SESSION default
  LOGICAL_READS_PER_CALL    default
  COMPOSITE_LIMIT           default
  PRIVATE_SGA               default
  FAILED_LOGIN_ATTEMPTS     default
  PASSWORD_LIFE_TIME        default
  PASSWORD_REUSE_TIME       default
  PASSWORD_REUSE_MAX        default
  PASSWORD_LOCK_TIME        default
  PASSWORD_GRACE_TIME       default
  PASSWORD_VERIFY_FUNCTION  default ;

ALTER PROFILE ND_USR_LOCK_AUTHONLY LIMIT
  SESSIONS_PER_USER         default
  CPU_PER_SESSION           default
  CPU_PER_CALL              default
  CONNECT_TIME              default
  IDLE_TIME                 default
  LOGICAL_READS_PER_SESSION default
  LOGICAL_READS_PER_CALL    default
  COMPOSITE_LIMIT           default
  PRIVATE_SGA               default
  FAILED_LOGIN_ATTEMPTS     default
  PASSWORD_LIFE_TIME        default
  PASSWORD_REUSE_TIME       default
  PASSWORD_REUSE_MAX        default
  PASSWORD_LOCK_TIME        default
  PASSWORD_GRACE_TIME       default
  PASSWORD_VERIFY_FUNCTION  default ;


