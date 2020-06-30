--1
create tablespace ts_mys
  datafile 'D:\Study\Databases\ts_mys.dbf'
  size 7 m
  autoextend on next 5m maxsize 20m
  online;

--2  
create temporary tablespace ts_mys_temp
  tempfile 'D:\Study\Databases\ts_mys_temp.dbf'
  size 5 m
  autoextend on next 3m maxsize 30m;

--3  
select TABLESPACE_NAME, STATUS, contents logging from SYS.DBA_TABLESPACES;

--4
alter session set "_ORACLE_SCRIPT" = true;
create role rl_myscore;
grant create session,
      create table,
      create view,
      create procedure to rl_myscore;
grant drop any table,
      drop any view,
      drop any procedure to rl_myscore;

--5
select * from dba_roles where role like 'RL%';
select * from dba_sys_privs where grantee = 'RL_MYSCORE';

--6
alter session set "_ORACLE_SCRIPT" = true;
create profile pf_myscore limit
  password_life_time 180
  sessions_per_user 3
  failed_login_attempts 7
  password_lock_time 1
  password_reuse_time 10
  password_grace_time default
  connect_time 180
  idle_time 30;
  
--7
select * from dba_profiles where profile = 'PF_MYSCORE';  
select * from dba_profiles where profile = 'DEFAULT'; 

--8
create user myscore identified by 12345
  default tablespace ts_mys quota unlimited on ts_mys
  temporary tablespace ts_mys_temp
  profile pf_myscore
  account unlock
  password expire;
  
grant rl_myscore to myscore;

--10
create table test 
( test_id int,
  test_name varchar(10)
);

insert into test(test_id, test_name) values (1, 'test');

create view test_view as
  select test_id from test;

--11
create tablespace mys_data
  datafile 'D:\Study\Databases\mys_data.dbf'
  size 10 m
  offline;
  
alter tablespace mys_data online;

alter session set "_ORACLE_SCRIPT" = true;
create user mys identified by 1234
default tablespace mys_data
quota 2m on mys_data;

grant create session to mys;

connect mys/1234;

create table mys_t1
(
  t1_id int not null,
  t1_name varchar(5)
);

insert into mys_t1(t1_id, t1_name) values (1, '1');
insert into mys_t1(t1_id, t1_name) values (2, '2');
insert into mys_t1(t1_id, t1_name) values (3, '3');