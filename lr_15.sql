--1.	�������� �������, ������� ��������� ���������, ���� �� ������� ��������� ����.

create table t15
(
  t_id integer not null primary key,
  t_val nvarchar2(32),
  t_num integer
);

--2.	��������� ������� �������� (10 ��.).

insert into t15(t_id, t_val, t_num) values (13, 'fre', 1);

--3.	�������� BEFORE � ������� ������ ��������� �� ������� INSERT, DELETE � UPDATE. 
--4.	���� � ��� ����������� �������� ������ �������� ��������� �� ��������� ������� (DMS_OUTPUT) �� ����� ����������� ������. 

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

--5.	�������� BEFORE-������� ������ ������ �� ������� INSERT, DELETE � UPDATE.

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

--6.	��������� ��������� INSERTING, UPDATING � DELETING.

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

--7.	������������ AFTER-�������� ������ ��������� �� ������� INSERT, DELETE � UPDATE.

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

--8.	������������ AFTER-�������� ������ ������ �� ������� INSERT, DELETE � UPDATE.

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

--9.	�������� ������� � ������ AUDIT. ������� ������ ��������� ����: OperationDate, 
--OperationType (�������� �������, ���������� � ��������),
--TriggerName(��� ��������),
--Data (������ � ���������� ����� �� � ����� ��������).

create table "AUDIT"
(
  OperationDate date,
  OperationType nvarchar2(10),
  TriggerName nvarchar2(25)
);

--10.	�������� �������� ����� �������, ����� ��� �������������� ��� �������� � �������� �������� � ������� AUDIT.

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

--11.	��������� ��������, ���������� ����������� ������� �� ���������� �����. ��������, ��������������� �� ������� ��� �������. ��������� ���������.

insert into t15(t_id, t_val, t_num) values (12, 'fre', 1);
select * from "AUDIT";

--12.	������� (drop) �������� �������. ��������� ���������. �������� �������, ����������� �������� �������� �������.

create or replace trigger tr_drop_table
before drop on SCHEMA
begin
  raise_application_error(-20000, 'Do not drop '||ORA_DICT_OBJ_TYPE||' '||ORA_DICT_OBJ_NAME);
end;

drop table t15;

drop trigger tr_drop_table;

--13.	������� (drop) ������� AUDIT. ����������� ��������� ��������� � ������� SQL-DEVELOPER. ��������� ���������. �������� ��������.

drop table "AUDIT";

--14.	�������� ������������� ��� �������� ��������. ������������ INSTEADOF INSERT-�������. ������� ������ ��������� ������ � �������.

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