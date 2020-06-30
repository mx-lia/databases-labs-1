--1.	Прочитайте задание полностью и выдайте своему пользователю необходимые права.

grant create sequence,
      create synonym,
      create public synonym,
      create view,
      create materialized view,
      create cluster to u1_mys_pdb;

--2.	Создайте последовательность S1 (SEQUENCE), со следующими характеристиками: начальное значение 1000; приращение 10;
--нет минимального значения; нет максимального значения; не циклическая; значения не кэшируются в памяти; хронология значений не гарантируется.
--Получите несколько значений последовательности. Получите текущее значение последовательности.

create sequence S1
increment by 10
start with 1000
nomaxvalue
nominvalue
nocycle
nocache
noorder;

select S1.nextval from dual;
select S1.currval from dual;

--3.	Создайте последовательность S2 (SEQUENCE), со следующими характеристиками: начальное значение 10; приращение 10; максимальное значение 100; 
--не циклическую. Получите все значения последовательности. Попытайтесь получить значение, выходящее за максимальное значение.

create sequence S2
increment by 10
start with 10
maxvalue 100
nominvalue
nocycle
nocache
noorder;

select S2.nextval from dual;
select S2.currval from dual;

--5.	Создайте последовательность S3 (SEQUENCE), со следующими характеристиками: начальное значение 10; приращение -10;
--минимальное значение -100; не циклическую; гарантирующую хронологию значений. Получите все значения последовательности. Попытайтесь получить значение, меньше минимального значения.

create sequence S3
increment by -10
nomaxvalue
minvalue -100
start with -10
nocycle
nocache
order;

select S3.nextval from dual;
select S3.currval from dual;

--6.	Создайте последовательность S4 (SEQUENCE), со следующими характеристиками: начальное значение 1; приращение 1; минимальное значение 10;
--циклическая; кэшируется в памяти 5 значений; хронология значений не гарантируется. Продемонстрируйте цикличность генерации значений последовательностью S4.

create sequence S4
increment by 1
maxvalue 10
nominvalue
start with 1
cycle
cache 5
noorder;

select S4.nextval from dual;
select S4.currval from dual;

--7.	Получите список всех последовательностей в словаре базы данных, владельцем которых является пользователь XXX.

select * from sys.user_sequences;

--8.	Создайте таблицу T1, имеющую столбцы N1, N2, N3, N4, типа NUMBER (20), кэшируемую и расположенную в буферном пуле KEEP.
--С помощью оператора INSERT добавьте 7 строк, вводимое значение для столбцов должно формироваться с помощью последовательностей S1, S2, S3, S4.

create table T1 
(
  N1 number(20),
  N2 number(20),
  N3 number(20),
  N4 number(20)
) storage (buffer_pool keep) cache;

insert into T1(N1, N2, N3, N4) values (S1.nextval, S2.nextval, S3.nextval, S4.nextval);

select * from T1;

--9.	Создайте кластер ABC, имеющий hash-тип (размер 200) и содержащий 2 поля: X (NUMBER (10)), V (VARCHAR2(12)).

create cluster ABC
(
  X number(10),
  V varchar2(12)
) hashkeys 200;

--10.	Создайте таблицу A, имеющую столбцы XA (NUMBER (10)) и VA (VARCHAR2(12)), принадлежащие кластеру ABC, а также еще один произвольный столбец.

create table A
(
  XA number(10),
  VA varchar2(12),
  RA number(10)
) cluster ABC(XA, VA);

--11.	Создайте таблицу B, имеющую столбцы XB (NUMBER (10)) и VB (VARCHAR2(12)), принадлежащие кластеру ABC, а также еще один произвольный столбец.

create table B
(
  XB number(10),
  VB varchar2(12),
  RB number(10)
) cluster ABC(XB, VB);

--12.	Создайте таблицу С, имеющую столбцы XС (NUMBER (10)) и VС (VARCHAR2(12)), принадлежащие кластеру ABC, а также еще один произвольный столбец. 

create table C
(
  XC number(10),
  VC varchar2(12),
  RC number(10)
) cluster ABC(XC, VC);

--13.	Найдите созданные таблицы и кластер в представлениях словаря Oracle.

select * from user_clusters;
select * from user_tables;

--14.	Создайте частный синоним для таблицы XXX.С и продемонстрируйте его применение.

create synonym u1_c for C;
select * from u1_c;

--15.	Создайте публичный синоним для таблицы XXX.B и продемонстрируйте его применение.

create public synonym u1_b for B;
select * from u1_b;

--16.	Создайте две произвольные таблицы A и B (с первичным и внешним ключами), заполните их данными, создайте представление V1, основанное на SELECT... FOR A inner join B.
--Продемонстрируйте его работоспособность.

create table A1
(
  A1_ID int primary key,
  A1_test varchar(10)
);

create table B1
(
  B1_ID int primary key,
  B1_test varchar(10),
  A1_ID int,
  constraint fk_ID foreign key (A1_ID) references A1(A1_ID)
);

insert into A1(A1_ID, A1_test) values (1, 'test');
insert into A1(A1_ID, A1_test) values (2, 'test');
insert into A1(A1_ID, A1_test) values (3, 'test');

insert into B1(B1_ID, B1_test, A1_ID) values (1, 'test', 1);
insert into B1(B1_ID, B1_test, A1_ID) values (2, 'test', 3);

create view V1 as select A1.A1_ID, A1.A1_test, B1.B1_ID, B1.B1_test from A1 inner join B1 on A1.A1_ID = B1.B1_ID;
select * from V1;

--17.	На основе таблиц A и B создайте материализованное представление MV, которое имеет периодичность обновления 2 минуты. Продемонстрируйте его работоспособность.

create materialized view VM
build immediate
refresh complete
start with (sysdate) next (sysdate+2/1440) with rowid as select A1.A1_ID, A1.A1_test, B1.B1_ID, B1.B1_test from A1 inner join B1 on A1.A1_ID = B1.B1_ID;

select * from VM;