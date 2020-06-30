--1.	������������ � ������� ORA12D. �������� DBLINK �� ����� USER1-USER2 ��� ����������� � ����� ���� ������ (���� �� ��������� �� ������� ORA12W). 

CREATE DATABASE LINK airtickets 
   CONNECT TO Programmer
   IDENTIFIED BY "1111"
   USING 'airtickets';
   
drop database link airtickets;

--2.	����������������� ���������� ���������� SELECT, INSERT, UPDATE, DELETE, ����� �������� � ������� � ��������� ���������� �������.

select * from "User"@airtickets;
insert into "User"@airtickets("Email", "Password") values ('fre', 'ferf');
update "User"@airtickets set "Password" = 'frefre' where "Email" = 'fre';
delete from "User"@airtickets where "Email" = 'fre';

--3.	�������� DBLINK �� ����� USER - GLOBAL.

CREATE PUBLIC DATABASE LINK public_airtickets 
   CONNECT TO Programmer
   IDENTIFIED BY "1111"
   USING 'airtickets';

--4.	����������������� ���������� ���������� SELECT, INSERT, UPDATE, DELETE, ����� �������� � ������� � ��������� ���������� �������

select * from "User"@public_airtickets;
insert into "User"@public_airtickets("Email", "Password") values ('fre', 'ferf');
update "User"@public_airtickets set "Password" = 'frefre' where "Email" = 'fre';
delete from "User"@public_airtickets where "Email" = 'fre';