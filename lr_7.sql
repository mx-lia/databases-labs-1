--1.	�������� ������ ������ ������� ���������. 

select name, description from v$bgprocess;

--2.	���������� ������� ��������, ������� �������� � �������� � ��������� ������.

select name, description from v$bgprocess where paddr != hextoraw('00') order by name;

--3.	����������, ������� ��������� DBWn �������� � ��������� ������.

select count(*) from v$bgprocess where paddr != hextoraw('00') and description like '%db writer process%';

--4.	�������� �������� ������� ���������� � �����������.
--5.	���������� ������ ���� ����������.

select username, sid, serial#, server, paddr, status from v$session where username is not null;

--6.	���������� ������� (����� ����������� ����������).

select addr, spid, pname from v$process where background is null order by pname;

--7.	�������� ��������� ��� ��������� ���������� � �� ��������.

show parameter dispatcher;

--8.	������� � ������ Windows-�������� ������, ����������� ������� LISTENER.

--Oracle TNSLSNR Executable

--9.	�������� �������� ������� ���������� � ���������. (dedicated, shared). 

select username, sid, serial#, server, paddr, status from v$session;

--10.	����������������� � �������� ���������� ����� LISTENER.ORA. 

--C:\app\Oracle\product\12.1.0\dbhome_1\NETWORK\ADMIN

--11.	��������� ������� lsnrctl � �������� �� �������� �������. 

--C:\app\Oracle\product\12.1.0\dbhome_1\BIN

--12.	�������� ������ ����� ��������, ������������� ��������� LISTENER.

select name, network_name, pdb from v$services;
