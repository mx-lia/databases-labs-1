select * from v$instance;
select * from v$pdbs;

create tablespace ts_mys_pdb
  datafile 'D:\Study\Databases\ts_mys_pdb.dbf'
  size 7 m
  autoextend on next 5m maxsize 20m
  online;
  
create temporary tablespace ts_mys_temp_pdb
  tempfile 'D:\Study\Databases\ts_mys_temp_pdb.dbf'
  size 5 m
  autoextend on next 3m maxsize 30m;
  
create role rl_mys_pdb;
grant create session,
      create table,
      create view,
      create procedure to rl_mys_pdb;
grant drop any table,
      drop any view,
      drop any procedure to rl_mys_pdb;
  
create profile pf_mys_pdb limit
  password_life_time 180
  sessions_per_user 3
  failed_login_attempts 7
  password_lock_time 1
  password_reuse_time 10
  password_grace_time default
  connect_time 180
  idle_time 30;

create user u1_mys_pdb identified by 12345
  default tablespace ts_mys_pdb quota unlimited on ts_mys_pdb
  temporary tablespace ts_mys_temp_pdb
  profile pf_mys_pdb
  account unlock;

grant rl_mys_pdb to u1_mys_pdb;

-----
create table mys_pdb
(
  test_id int not null,
  test_name varchar(10)
);

insert into mys_pdb(test_id, test_name) values (1, '1');
insert into mys_pdb(test_id, test_name) values (2, '2');
insert into mys_pdb(test_id, test_name) values (3, '3');

select * from mys_pdb;

select * from v$tablespace;
select * from v$instance;
select * from v$sessions;
select * from dba_roles;
----------
grant connect to c##mys;

grant create table to c##mys;

create table mys_pdb
(
  test_id int not null,
  test_name varchar(10)
);

