--1. �������� ������ ���� ������ ��������� ����������� (������������  � ���������).

select t.name "Tablespace", f.name "Datafile" from v$tablespace t, v$datafile f where t.ts# = f.ts# order by t.name;

--2. �������� ��������� ������������ � ������ XXX_QDATA (10m). ��� �������� ���������� ��� � ��������� offline.
--����� ���������� ��������� ������������ � ��������� online. �������� ������������ XXX ����� 2m � ������������ XXX_QDATA. 
--�� ����� XXX �  ������������ XXX_T1�������� ������� �� ���� ��������, ���� �� ������� ����� �������� ��������� ������. � ������� �������� 3 ������.

create tablespace mys_qdata
  datafile 'D:\Study\Databases\mys_data.dbf'
  size 10 m
  offline;
  
alter tablespace mys_qdata online;

alter session set "_ORACLE_SCRIPT" = true;

alter user mys identified by 1234
default tablespace mys_qdata
quota 2m on mys_qdata;

grant create table,
      drop any table to mys;

connect mys/1234;
create table mys_t1
(
  id_t1 int primary key,
  name_t1 varchar(10)
);

insert into mys_t1(id_t1, name_t1) values (1, 'test1');
insert into mys_t1(id_t1, name_t1) values (2, 'test2');
insert into mys_t1(id_t1, name_t1) values (3, 'test3');

--3. �������� ������ ��������� ���������� ������������  XXX_QDATA. ���������� ������� ������� XXX_T1. ���������� ��������� ��������.

select * from dba_segments where tablespace_name = 'MYS_QDATA';

--4. ������� (DROP) ������� XXX_T1. �������� ������ ��������� ���������� ������������  XXX_QDATA. ���������� ������� ������� XXX_T1. 
--��������� SELECT-������ � ������������� USER_RECYCLEBIN, �������� ���������.

connect mys/1234;
drop table mys_t1;

select * from dba_segments where tablespace_name = 'MYS_QDATA';
select * from user_recyclebin;

--5. ������������ (FLASHBACK) ��������� �������. 

connect mys/1234;
flashback table mys_t1 to before drop;

--6. ��������� PL/SQL-������, ����������� ������� XXX_T1 ������� (10000 �����). 

connect mys/1234;
begin
delete from mys_t1;
for k in 1..10000
loop
  insert into mys_t1(id_t1, name_t1) values (k, 'test');
end loop;
commit;
end;

--7. ���������� ������� � �������� ������� XXX_T1 ���������, �� ������ � ������ � ������. �������� �������� ���� ���������. 

select segment_name, segment_type, tablespace_name, bytes, blocks, extents, buffer_pool from dba_segments where tablespace_name = 'MYS_QDATA';
select * from dba_extents where tablespace_name = 'MYS_QDATA';

--8. ������� ��������� ������������ XXX_QDATA � ��� ����. 

drop tablespace MYS_QDATA including contents and datafiles;

--9. �������� �������� ���� ����� �������� �������. ���������� ������� ������ �������� �������.

select * from v$logfile;
select group#, status, members from v$log;

--10. �������� �������� ������ ���� �������� ������� ��������.



--11. EX. � ������� ������������ �������� ������� �������� ������ ���� ������������. 
--�������� ��������� ����� � ������ ������ ������� ������������ (��� ����������� ��� ���������� ��������� �������).

alter system switch logfile; --19.06
select group#, status, members from v$log;

--12. EX. �������� �������������� ������ �������� ������� � ����� ������� �������. 
--��������� � ������� ������ � ������, � ����� � ����������������� ������ (�������������). ���������� ������������������ SCN. 

alter database add logfile group 4 'C:\APP\ORACLE\ORADATA\ORCL\REDO04.LOG'
size 50m blocksize 512;

select * from v$log;

alter database add logfile member 'C:\APP\ORACLE\ORADATA\ORCL\REDO041.LOG' to group 4;
alter database add logfile member 'C:\APP\ORACLE\ORADATA\ORCL\REDO042.LOG' to group 4;

select * from v$log;

--13. EX. ������� ��������� ������ �������� �������. ������� ��������� ���� ����� �������� �� �������.

alter database drop logfile member 'C:\APP\ORACLE\ORADATA\ORCL\REDO041.LOG';
alter database drop logfile member 'C:\APP\ORACLE\ORADATA\ORCL\REDO042.LOG';

alter database drop logfile group 4;

select * from v$log;

--14. ����������, ����������� ��� ��� ������������� �������� ������� (������������� ������ ���� ���������, 
--����� ���������, ���� ������ ������� �������� ������� � ��������).

select name, log_mode from v$database;

--15. ���������� ����� ���������� ������.  
--16. EX.  �������� �������������. 

select name, log_mode from v$database;

--17. EX. ������������� �������� �������� ����. ���������� ��� �����. ���������� ��� �������������� � ��������� � ��� �������. 
--���������� ������������������ SCN � ������� � �������� �������. 

select instance_name, archiver, active_state from v$instance;
select * from v$log;
select * from v$archived_log;
archive log list;
show parameter db_recovery;

--18. EX. ��������� �������������. ���������, ��� ������������� ���������.  

select instance_name, archiver, active_state from v$instance;

--19. �������� ������ ����������� ������.

select * from v$controlfile;

--20. �������� � ���������� ���������� ������������ �����. �������� ��������� ��� ��������� � �����.

--21. ���������� �������������� ����� ���������� ��������. ��������� � ������� ����� �����. 

select name, value from v$parameter where name = 'open_cursors';

--22. ����������� PFILE � ������ XXX_PFILE.ORA. ���������� ��� ����������. �������� ��������� ��� ��������� � �����.

create pfile = 'p1.ora' from spfile;

--23. ���������� �������������� ����� ������� ��������. ��������� � ������� ����� �����. 

select * from v$pwfile_users;

--24. �������� �������� ����������� ��� ������ ��������� � �����������. 

select * from v$diag_info;

--25. EX. ������� � ���������� ���������� ��������� ������ �������� (LOG.XML), ������� � ��� ������� ������������ �������� ������� �� ���������.
