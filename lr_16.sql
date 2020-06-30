--1.	Создайте таблицу T_RANGE c диапазонным секционированием. Используйте ключ секционирования типа NUMBER. 

create tablespace data00
        datafile 'data00.dbf'
        size 1m autoextend on;
      
create tablespace data01
        datafile 'data01.dbf'
        size 1m autoextend on;
        
create tablespace data02
        datafile 'data02.dbf'
        size 1m autoextend on;

create tablespace data03
        datafile 'data03.dbf'
        size 1m autoextend on;
        
create tablespace data04
        datafile 'data04.dbf'
        size 1m autoextend on;

create table T_RANGE 
(
  table_key NUMBER,
  table_value NVARCHAR2(10)
)
partition by range(table_key)
(
  partition t_range1 values less than (100) tablespace data00,
  partition t_range2 values less than (400) tablespace data01,
  partition t_range3 values less than (800) tablespace data02,
  partition t_range4 values less than (1200) tablespace data03,
  partition t_range_max values less than (1500) tablespace data04
);

--2.	Создайте таблицу T_INTERVAL c интервальным секционированием. Используйте ключ секционирования типа DATE.

create table T_INTERVAL (x1 NUMBER, x2 DATE)
partition by range(x2)
interval(NUMTOYMINTERVAL(1, 'MONTH')) store in (users)
(
  PARTITION p0 VALUES LESS THAN (TO_DATE('1-1-2006', 'DD-MM-YYYY')),
  PARTITION p1 VALUES LESS THAN (TO_DATE('1-1-2007', 'DD-MM-YYYY')),
  PARTITION p2 VALUES LESS THAN (TO_DATE('1-7-2008', 'DD-MM-YYYY')),
  PARTITION p3 VALUES LESS THAN (TO_DATE('1-1-2009', 'DD-MM-YYYY'))
);

--3.	Создайте таблицу T_HASH c хэш-секционированием. Используйте ключ секционирования типа VARCHAR2.

create table T_HASH (x1 NUMBER, x2 NVARCHAR2(10))
partition by hash (x2)
partitions 16
store in (data00, data01, data02, data03);

--4.	Создайте таблицу T_LIST со списочным секционированием. Используйте ключ секционирования типа CHAR.

create table T_LIST (x1 NUMBER, x2 CHAR)
partition by list (x2)
(
  partition t_list1 values('A', 'F'),
  partition t_list2 values('G', 'M'),
  partition t_list_others values(default)
);

--5.	Введите с помощью операторов INSERT данные в таблицы T_RANGE, T_INTERVAL, T_HASH, T_LIST.
--Данные должны быть такими, чтобы они разместились по всем секциям. Продемонстрируйте это с помощью SELECT запроса. 

insert into T_RANGE(table_key, table_value) values (50, 'fifthy');
insert into T_RANGE(table_key, table_value) values (200, '200');
insert into T_RANGE(table_key, table_value) values (500, '500');
insert into T_RANGE(table_key, table_value) values (1000, '1000');
insert into T_RANGE(table_key, table_value) values (1400, '1400');

select * from T_RANGE partition(t_range1);
select * from T_RANGE partition(t_range2);
select * from T_RANGE partition(t_range3);
select * from T_RANGE partition(t_range4);
select * from T_RANGE partition(t_range_max);

insert into T_INTERVAL(x1, x2) values (1, TO_DATE('1-1-2005', 'DD-MM-YYYY'));
insert into T_INTERVAL(x1, x2) values (1, TO_DATE('1-1-2006', 'DD-MM-YYYY'));
insert into T_INTERVAL(x1, x2) values (1, TO_DATE('1-1-2007', 'DD-MM-YYYY'));
insert into T_INTERVAL(x1, x2) values (1, TO_DATE('1-9-2008', 'DD-MM-YYYY'));

select * from T_INTERVAL partition (p0);
select * from T_INTERVAL partition (p1);
select * from T_INTERVAL partition (p2);
select * from T_INTERVAL partition (p3);

insert into T_HASH(x1, x2) values(1, 'test1');
insert into T_HASH(x1, x2) values(2, 'test2');
insert into T_HASH(x1, x2) values(3, 'test3');
insert into T_HASH(x1, x2) values(4, 'test4');

select * from user_TAB_PARTITIONS where table_name='T_HASH';
select * from T_HASH partition (SYS_P1312);
select * from T_HASH partition (SYS_P1313);
select * from T_HASH partition (SYS_P1314);
select * from T_HASH partition (SYS_P1315);
select * from T_HASH partition (SYS_P1316);

insert into T_LIST(x1, x2) values(1, 'A');
insert into T_LIST(x1, x2) values(1, 'G');
insert into T_LIST(x1, x2) values(1, 'Y');

select * from T_LIST partition(t_list1);
select * from T_LIST partition(t_list2);
select * from T_LIST partition(t_list_others);

--6.	Продемонстрируйте для всех таблиц процесс перемещения строк между секциями, при изменении (оператор UPDATE) ключа секционирования.

alter table T_LIST enable row movement;
update T_LIST set x2 = 'A' where x2 = 'Y';

--7.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE MERGE.

ALTER TABLE T_LIST MERGE PARTITIONS 
t_list1, t_list2 into partition t_list12; 

--8.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE SPLIT.

alter table t_range split partition t_range3 at (600) into
(partition t_range_add1 tablespace data01,
partition t_range_add2 tablespace data02);

--9.	Для одной из таблиц продемонстрируйте действие оператора ALTER TABLE EXCHANGE.

create table MY_T_RANGE 
(
  table_key NUMBER,
  table_value NVARCHAR2(10)
);

alter table t_range exchange partition t_range1 with table my_t_range without validation;
