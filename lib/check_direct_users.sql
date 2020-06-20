set pagesize 0
set linesize 300
set trimout on
set heading off
set feedback off
set serveroutput on

select lower(username) || ',' || name || ',' ||  profile || ',' || account_status 
from dba_users, v$database
where (profile like 'ND_USR_OPEN%') 
and (profile not like '%INBUSER') 
and (profile not like '%EPRINT') 
and (profile not like '%BOSSCARS')
and (profile not like '%DEFAULT')
and (profile not like '%ADVUSER%')
and (profile not like '%SMARTCALL')
and (profile not like '%TRAINING%')
and (username not like 'TRAINEE%')
and (username not like '%ASSYST')
order by username
/
