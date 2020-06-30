--1.	���������� ����� ������ ������� SGA.

select sum(value) from v$sga;

--2.	���������� ������� ������� �������� ����� SGA.

show parameter sga_target;

--3.	���������� ������� ������� ��� ������� ����.

select  component,
        current_size, 
        max_size, 
        last_oper_mode, 
        last_oper_time, 
        granule_size, 
        current_size/granule_size as Ratio
from v$sga_dynamic_components
where current_size > 0;

--4.	���������� ����� ��������� ��������� ������ � SGA.

select (sum(max_size)) - (sum(current_size)) from v$sga_dynamic_components;

--5.	���������� ������� ����� ���P, DEFAULT � RECYCLE ��������� ����.

select component, min_size, current_size from v$sga_dynamic_components where component like '%cache%';

--6.	�������� �������, ������� ����� ���������� � ��� ���P. ����������������� ������� �������.

connect mys/1234;
create table KKK (k int) storage (buffer_pool keep) tablespace users;

insert into KKK values(1);
commit;

select segment_name, segment_type, tablespace_name, buffer_pool from user_segments 
                                                                where segment_name='KKK';

--7.	�������� �������, ������� ����� ������������ � ���� default. ����������������� ������� �������.

create table DDD (k int) storage (buffer_pool default) tablespace users;

insert into DDD values(1);
commit;

select segment_name, segment_type, tablespace_name, buffer_pool from user_segments 
                                                                where segment_name='DDD';

--8.	������� ������ ������ �������� �������.

show parameter log_buffer;

--9.	������� 10 ����� ������� �������� � ����������� ����.

select * from (select pool, name, bytes from v$sgastat where pool = 'shared pool' order by bytes desc)
          where rownum <= 10;

--10.	������� ������ ��������� ������ � ������� ����.

select pool, name, bytes from v$sgastat where pool = 'large pool' and name = 'free memory';

--11.	�������� �������� ������� ���������� � ���������. 

select * from v$session;

--12.	���������� ������ ������� ���������� � ��������� (dedicated, shared).

select sid, server from v$session;


