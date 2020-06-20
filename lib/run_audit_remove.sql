-- ---------------------------------------------------------------------
-- File: sql/run_audit_remove.sql
-- Desc:
--
-- Audit Trail:
-- 01-Jul-2013  John Grover
--  - Original Code
-- ---------------------------------------------------------------------

--
-- Remove statement audits
--
select 'noaudit ' || audit_option ||
       ' by ' || user_name || ' ;' "--SQL1"
  from dba_stmt_audit_opts
 order by user_name, audit_option;

--
-- Remove privilege audits
--
select 'noaudit ' || privilege ||
       ' by ' || user_name || ' ;' "--SQL2"
  from dba_priv_audit_opts
 order by user_name, privilege;
--
-- Remove object audits
--
SELECT 'noaudit ' || 
       DECODE(ALT, '-/-', NULL, 'ALTER, ') || 
       DECODE(AUD, '-/-', NULL, 'AUDIT, ') || 
       DECODE(COM, '-/-', NULL, 'COMMENT, ') || 
       DECODE(DEL, '-/-', NULL, 'DELETE, ') || 
       DECODE(GRA, '-/-', NULL, 'GRANT, ') || 
       DECODE(IND, '-/-', NULL, 'INDEX, ') || 
       DECODE(INS, '-/-', NULL, 'INSERT, ') || 
       DECODE(LOC, '-/-', NULL, 'LOCAL, ') || 
       DECODE(REN, '-/-', NULL, 'RENAME, ') || 
       DECODE(SEL, '-/-', NULL, 'SELECT, ') || 
       DECODE(UPD, '-/-', NULL, 'UPDATE, ') || 
       DECODE(REF, '-/-', NULL, 'REFERENCE, ') || 
       DECODE(EXE, '-/-', NULL, 'EXECUTE, ') || 
       DECODE(CRE, '-/-', NULL, 'CREATE, ') || 
       DECODE(REA, '-/-', NULL, 'READ, ') || 
       DECODE(WRI, '-/-', NULL, 'WRITE, ') || 
       DECODE(FBK, '-/-', NULL, 'FLASHBACK, ') || 
       ' on ' || owner || '.' || object_name "--SQL3"
  from dba_obj_audit_opts
 order by object_type, owner, object_name;
--
--
--
exit;

