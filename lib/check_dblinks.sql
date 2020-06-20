--
-- ND Check DB Links
--
--
-- ND Check DB Links
--
select l.owner, u.profile, l.db_link, d.name, l.host, l.username
  from dba_db_links l, dba_users u, v$database d
 where u.username = l.owner and not (
(  upper(d.name) like '%DEV%'  and  upper(l.host) like '%DEV%') or
(  upper(d.name) like '%TEST%' and  upper(l.host) like '%TEST%') or
(  upper(d.name) like '%TEST%' and upper (l.host) like '%PPRD%') or
(  upper(d.name) like '%PPRD%' and upper (l.host) like '%TEST%') or
(  upper(d.name) like '%DEV%'  and upper (l.host) like '%DEV%') )

exit;
