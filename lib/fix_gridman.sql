-- create role nd_gridman_repo_q_role ;
-- create role nd_gridman_repo_u_role ;

grant nd_gridman_repo_q_role to gridman;
grant nd_gridman_repo_u_role to gridman;

grant select on ndrepoadmin.db_backups to nd_gridman_repo_q_role;
grant select, update, insert, delete on ndrepoadmin.db_backups to nd_gridman_repo_u_role;

