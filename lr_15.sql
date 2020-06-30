--1.	Создайте таблицу, имеющую несколько атрибутов, один из которых первичный ключ.

create table t15
(
  t_id integer not null primary key,
  t_val nvarchar2(32),
  t_num integer
);

--2.	Заполните таблицу строками (10 шт.).

insert into t15(t_id, t_val, t_num) values (13, 'fre', 1);

--3.	Создайте BEFORE – триггер уровня оператора на события INSERT, DELETE и UPDATE. 
--4.	Этот и все последующие триггеры должны выдавать сообщение на серверную консоль (DMS_OUTPUT) со своим собственным именем. 

create or replace trigger t15_before_insert
before insert on t15
  begin
    dbms_output.put_line('t15_before_insert');
  end;
  
create or replace trigger t15_before_update
before update on t15
  begin
    dbms_output.put_line('t15_before_update');
  end;
  
create or replace trigger t15_before_delete
before delete on t15
  begin
    dbms_output.put_line('t15_before_delete');
  end;

--5.	Создайте BEFORE-триггер уровня строки на события INSERT, DELETE и UPDATE.

create or replace trigger t15_before_insert_row
before insert on t15
for each row
  begin
    dbms_output.put_line('t15_before_insert_row');
  end;
  
create or replace trigger t15_before_update_row
before update on t15
for each row
  begin
    dbms_output.put_line('t15_before_update_row');
  end;
  
create or replace trigger t15_before_delete_row
before delete on t15
for each row
  begin
    dbms_output.put_line('t15_before_delete_row');
  end;

--6.	Примените предикаты INSERTING, UPDATING и DELETING.

create or replace trigger t15_before_predicats
before insert or update or delete on t15
begin
  if inserting then
    dbms_output.put_line('t15_before_insert_predicats');
  elsif updating then
    dbms_output.put_line('t15_before_update_predicats');
  elsif deleting then
    dbms_output.put_line('t15_before_delete_predicats');
  end if;
end;

--7.	Разработайте AFTER-триггеры уровня оператора на события INSERT, DELETE и UPDATE.

create or replace trigger t15_after_insert
after insert on t15
  begin
    dbms_output.put_line('t15_after_insert');
  end;
  
create or replace trigger t15_after_update
after update on t15
  begin
    dbms_output.put_line('t15_after_update');
  end;
  
create or replace trigger t15_after_delete
after delete on t15
  begin
    dbms_output.put_line('t15_after_delete');
  end;

--8.	Разработайте AFTER-триггеры уровня строки на события INSERT, DELETE и UPDATE.

create or replace trigger t15_after_insert_row
after insert on t15
for each row
  begin
    dbms_output.put_line('t15_after_insert_row');
  end;
  
create or replace trigger t15_after_update_row
after update on t15
for each row
  begin
    dbms_output.put_line('t15_after_update_row');
  end;
  
create or replace trigger t15_after_delete_row
after delete on t15
for each row
  begin
    dbms_output.put_line('t15_after_delete_row');
  end;

--9.	Создайте таблицу с именем AUDIT. Таблица должна содержать поля: OperationDate, 
--OperationType (операция вставки, обновления и удаления),
--TriggerName(имя триггера),
--Data (строка с значениями полей до и после операции).

create table "AUDIT"
(
  OperationDate date,
  OperationType nvarchar2(10),
  TriggerName nvarchar2(25)
);

--10.	Измените триггеры таким образом, чтобы они регистрировали все операции с исходной таблицей в таблице AUDIT.

create or replace trigger t15_before_insert
before insert on t15
  begin
    insert into "AUDIT"(OperationDate, OperationType, TriggerName)
                values (sysdate, 'insert', 't15_before_insert');
  end;
  
create or replace trigger t15_before_update
before update on t15
  begin
    insert into "AUDIT"(OperationDate, OperationType, TriggerName)
                values (sysdate, 'update', 't15_before_update');
  end;
  
create or replace trigger t15_before_delete
before delete on t15
  begin
    insert into "AUDIT"(OperationDate, OperationType, TriggerName)
                values (sysdate, 'delete', 't15_before_delete');
  end;

--11.	Выполните операцию, нарушающую целостность таблицы по первичному ключу. Выясните, зарегистрировал ли триггер это событие. Объясните результат.

insert into t15(t_id, t_val, t_num) values (12, 'fre', 1);
select * from "AUDIT";

--12.	Удалите (drop) исходную таблицу. Объясните результат. Добавьте триггер, запрещающий удаление исходной таблицы.

create or replace trigger tr_drop_table
before drop on SCHEMA
begin
  raise_application_error(-20000, 'Do not drop '||ORA_DICT_OBJ_TYPE||' '||ORA_DICT_OBJ_NAME);
end;

drop table t15;

drop trigger tr_drop_table;

--13.	Удалите (drop) таблицу AUDIT. Просмотрите состояние триггеров с помощью SQL-DEVELOPER. Объясните результат. Измените триггеры.

drop table "AUDIT";

--14.	Создайте представление над исходной таблицей. Разработайте INSTEADOF INSERT-триггер. Триггер должен добавлять строку в таблицу.

create view t15_view as select t_id ua, t_val na, t_num ca from t15;

create or replace trigger tr_t15
instead of insert on t15_view
for each row
begin
  if inserting then
    dbms_output.put_line('insert'||:new.ua);
  elsif updating then
    dbms_output.put_line('update'||rtrim(:old.ca)||' -> '||:new.ca);
  elsif deleting then
    dbms_output.put_line('delete'||:old.ua);
  end if;
end;

insert into t15_view(ua, na, ca) values (14, 'fre', 1);
update t15_view set ca = 2;
delete t15_view;