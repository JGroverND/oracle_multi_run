--
-- File: AuditCheck.sql
-- Desc: Show what audits are in effect
--
-- Audit Trail:
-- 01-Jul-2013 jgrover
--  Original Code
--

set PAGES 9999
set LINES 128
set TRIMS on
set TRIM on
set HEAD on
set FEED on
set ECHO off
set VER off
set WRA off

--
-- What is audited?
--
select 'audit STATEMENT ' || audit_option ||
       ' by ' || user_name ||
       ' success ' || success ||
       ' failure ' || failure "Statement Audits"
  from dba_stmt_audit_opts
 order by user_name, audit_option;
--
--
--
select 'audit PRIVILEGE ' || privilege ||
       ' by ' || user_name ||
       ' success ' || success ||
       ' failure ' || failure "Privilege Audits"
  from dba_priv_audit_opts
 order by user_name, privilege;
--
--
--
select 'audit OBJECT ' || object_type || ' ' || owner || '.' || object_name "Object Audits",
       alt, aud, com, del, gra, ind, ins, loc,
       ren, sel, upd, ref, exe, cre, rea, wri, fbk
  from dba_obj_audit_opts
 order by object_type, owner, object_name;

exit;

