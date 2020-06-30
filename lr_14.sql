--1.	Подключитесь к серверу ORA12D. Создайте DBLINK по схеме USER1-USER2 для подключения к вашей базе данных (ваша БД находится на сервере ORA12W). 

CREATE DATABASE LINK airtickets 
   CONNECT TO Programmer
   IDENTIFIED BY "1111"
   USING 'airtickets';
   
drop database link airtickets;

--2.	Продемонстрируйте выполнение операторов SELECT, INSERT, UPDATE, DELETE, вызов процедур и функций с объектами удаленного сервера.

select * from "User"@airtickets;
insert into "User"@airtickets("Email", "Password") values ('fre', 'ferf');
update "User"@airtickets set "Password" = 'frefre' where "Email" = 'fre';
delete from "User"@airtickets where "Email" = 'fre';

--3.	Создайте DBLINK по схеме USER - GLOBAL.

CREATE PUBLIC DATABASE LINK public_airtickets 
   CONNECT TO Programmer
   IDENTIFIED BY "1111"
   USING 'airtickets';

--4.	Продемонстрируйте выполнение операторов SELECT, INSERT, UPDATE, DELETE, вызов процедур и функций с объектами удаленного сервера

select * from "User"@public_airtickets;
insert into "User"@public_airtickets("Email", "Password") values ('fre', 'ferf');
update "User"@public_airtickets set "Password" = 'frefre' where "Email" = 'fre';
delete from "User"@public_airtickets where "Email" = 'fre';