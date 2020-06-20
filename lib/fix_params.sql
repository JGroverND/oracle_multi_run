alter system set resource_limit=true scope=spfile sid='*';
alter system set AUDIT_SYS_OPERATIONS=true scope=spfile sid='*';
alter system set sql92_security=true scope=spfile sid='*';
alter system set OS_AUTHENT_PREFIX='' scope=spfile sid='*';

exit;

