--1. �������� � ������� TEACHERS ��� ������� BIRTHDAY� SALARY, ��������� �� ����������.

alter table teacher add birthday date;
alter table teacher add salary number(8,2);

declare 
  cursor c_teachers is select teacher, birthday, salary from teacher for update of birthday, salary;
begin
  for r_teacher in c_teachers
  loop
    update teacher set birthday = (select to_date('1964-01-01', 'yyyy-mm-dd')+trunc(dbms_random.value(1,10000)) from dual) where teacher = r_teacher.teacher;
    update teacher set salary = (select dbms_random.value(800, 1100) from dual) where teacher = r_teacher.teacher;
  end loop;
end;

--2. �������� ������ �������������� � ���� ������� �.�.

select regexp_substr(teacher_name, '\S+', 1, 1)||' '||substr(regexp_substr(teacher_name, '\S+', 1, 2), 1, 1)||'. '||substr(regexp_substr(teacher_name, '\S+', 1, 3), 1, 1)||'. ' from teacher;

--3. �������� ������ ��������������, ���������� � �����������.

select * from teacher where to_char((birthday), 'day') = '�����������';

--4. �������� �������������, � ������� ��������� ������ ��������������, ������� �������� � ��������� ������.

create view next_month as select * from teacher where to_char(sysdate,'mm') + 1 = to_char(birthday, 'mm');
select * from next_month;

--5. �������� �������������, � ������� ��������� ���������� ��������������, ������� �������� � ������ ������.

create view count_birth_each_month as select to_char(birthday, 'month') as mon, count(*) as cnt from teacher group by(to_char(birthday, 'month'));
select * from count_birth_each_month;

--6. ������� ������ � ������� ������ ��������������, � ������� � ��������� ���� ������.

cursor teacher_anniversary(teacher%rowtype) 
    return teacher%rowtype is
    select * from teacher where mod((to_char(sysdate,'yyyy') - to_char(birthday, 'yyyy') + 1), 5)=0;

--7. ������� ������ � ������� ������� ���������� ����� �� �������� � ����������� ���� �� �����, ������� ������� �������� �������� ��� ������� ���������� � ��� ���� ����������� � �����.

cursor avg_salary_pulpit(teacher%rowtype) 
    return teacher%rowtype is
    select pulpit, trunc(avg(salary)) as avg_slr from teacher group by pulpit;
    
cursor avg_salary_faculty(teacher%rowtype) 
    return teacher%rowtype is
    select f.faculty, trunc(avg(t.salary)) as avg_slr from teacher t, pulpit p, faculty f where (t.pulpit = p.pulpit and p.faculty = f.faculty) group by f.faculty;
    
cursor avg_salary(teacher%rowtype) 
    return teacher%rowtype is
    select trunc(avg(salary)) as avg_slr from teacher;

--8. �������� ����������� ��� PL/SQL-������ (record) � ����������������� ������ � ���. ����������������� ������ � ���������� ��������. ����������������� � ��������� �������� ����������. 

DECLARE
    TYPE ADDRESS IS RECORD
    (
      TOWN NVARCHAR2(20),
      COUNTRY NVARCHAR2(20)
    );
    TYPE PERSON IS RECORD
    (
      NAME TEACHER.TEACHER_NAME%TYPE,
      PULP TEACHER.PULPIT%TYPE,
      homeAddress ADDRESS
    );
  per1 PERSON;
  per2 PERSON;
BEGIN
  SELECT TEACHER_NAME, PULPIT INTO per1.NAME, per1.PULP
  FROM TEACHER
  WHERE TEACHER='����';
  per1.homeAddress.TOWN := '������';
  per1.homeAddress.COUNTRY := '��������';
  per2 := per1;
  DBMS_OUTPUT.PUT_LINE(per2.NAME||' '||per2.PULP||' �� '||per2.homeAddress.TOWN||' '||per2.homeAddress.COUNTRY);
END;
