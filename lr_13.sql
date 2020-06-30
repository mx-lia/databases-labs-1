--1. Разработайте локальную процедуру 
--GET_TEACHERS (PCODE TEACHER.PULPIT%TYPE) 
--Процедура должна выводить список преподавателей из таблицы TEACHER (в стандартный серверный вывод),
--работающих на кафедре заданной кодом в параметре. Разработайте анонимный блок и продемонстрируйте выполнение процедуры.

create or replace procedure mys.get_teachers(pcode in teacher.pulpit%type)
is
  c1 sys_refcursor;
  t_name varchar2(50);
begin
  open c1 for
  select teacher_name from teacher where pulpit = pcode;
  loop
    fetch c1 into t_name;
    exit when c1%notfound;
    dbms_output.put_line(t_name);
  end loop;
end get_teachers;

begin
  get_teachers('ИСиТ');
end;

--2. Разработайте локальную функцию 
--3. GET_NUM_TEACHERS (PCODE TEACHER.PULPIT%TYPE) 
--RETURN NUMBER
--Функция должна выводить количество преподавателей из таблицы TEACHER, работающих на кафедре заданной кодом в параметре.
--Разработайте анонимный блок и продемонстрируйте выполнение процедуры.

create or replace function get_num_teachers(pcode in teacher.pulpit%type)
return number is
  rc number(5);
begin
  select count(*) into rc from teacher where pulpit = pcode;
  return rc;
end;

begin
  dbms_output.put_line(get_num_teachers('ИСиТ'));
end;

--4. Разработайте процедуры:
--GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
--Процедура должна выводить список преподавателей из таблицы TEACHER (в стандартный серверный вывод), работающих на факультете, заданным кодом в параметре. Разработайте анонимный блок и продемонстрируйте выполнение процедуры.
--GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
--Процедура должна выводить список дисциплин из таблицы SUBJECT, закрепленных за кафедрой, заданной кодом кафедры в параметре. Разработайте анонимный блок и продемонстрируйте выполнение процедуры.

create or replace procedure mys.get_teachers_fac(fcode in faculty.faculty%type)
is
  c1 sys_refcursor;
  t_name varchar2(50);
begin
  open c1 for
  select teacher_name from teacher inner join pulpit on teacher.pulpit = pulpit.pulpit where pulpit.faculty = fcode;
  loop
    fetch c1 into t_name;
    exit when c1%notfound;
    dbms_output.put_line(t_name);
  end loop;
end;

begin
  get_teachers_fac('ИЭФ');
end;

create or replace procedure mys.get_subjects(pcode in subject.pulpit%type)
is
  c1 sys_refcursor;
  t_name varchar2(50);
begin
  open c1 for
  select subject_name from subject where pulpit = pcode;
  loop
    fetch c1 into t_name;
    exit when c1%notfound;
    dbms_output.put_line(t_name);
  end loop;
end;

begin
  get_subjects('ИСиТ');
end;

--5. Разработайте локальную функцию 
--GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
--RETURN NUMBER
--Функция должна выводить количество преподавателей из таблицы TEACHER, работающих на факультете, заданным кодом в параметре. Разработайте анонимный блок и продемонстрируйте выполнение процедуры.
--GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER Функция должна выводить количество дисциплин из таблицы SUBJECT, закрепленных за кафедрой, заданной кодом кафедры параметре. Разработайте анонимный блок и продемонстрируйте выполнение процедуры. 

create or replace function get_num_teachers_fac(fcode in faculty.faculty%type)
return number is
  rc number(5);
begin
  select count(*) into rc from teacher inner join pulpit on teacher.pulpit = pulpit.pulpit where pulpit.faculty = fcode;
  return rc;
end;

begin
  dbms_output.put_line(get_num_teachers_fac('ИЭФ'));
end;

create or replace function get_num_subjects(pcode in subject.pulpit%type)
return number is
  rc number(5);
begin
  select count(*) into rc from subject where pulpit = pcode;
  return rc;
end;

begin
  dbms_output.put_line(get_num_subjects('ИСиТ'));
end;

--6. Разработайте пакет TEACHERS, содержащий процедуры и функции:
--GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
--GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
--GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER 

create or replace package teachers as
  type rec is record
  (
  pcode subject.pulpit%type,
  fcode faculty.faculty%type
  );
  
  procedure get_teachers_fac(fcode faculty.faculty%type);
  function get_num_teachers_fac(fcode faculty.faculty%type) return number;
  procedure get_subjects(pcode subject.pulpit%type);
  function get_num_subjects(pcode subject.pulpit%type) return number;
  
end teachers;

create or replace package body teachers is

procedure get_teachers_fac(fcode in faculty.faculty%type)
is
  c1 sys_refcursor;
  t_name varchar2(50);
begin
  open c1 for
  select teacher_name from teacher inner join pulpit on teacher.pulpit = pulpit.pulpit where pulpit.faculty = fcode;
  loop
    fetch c1 into t_name;
    exit when c1%notfound;
    dbms_output.put_line(t_name);
  end loop;
end;

function get_num_teachers_fac(fcode in faculty.faculty%type)
return number is
  rc number(5);
begin
  select count(*) into rc from teacher inner join pulpit on teacher.pulpit = pulpit.pulpit where pulpit.faculty = fcode;
  return rc;
end;

procedure get_subjects(pcode in subject.pulpit%type)
is
  c1 sys_refcursor;
  t_name varchar2(50);
begin
  open c1 for
  select subject_name from subject where pulpit = pcode;
  loop
    fetch c1 into t_name;
    exit when c1%notfound;
    dbms_output.put_line(t_name);
  end loop;
end;

function get_num_subjects(pcode in subject.pulpit%type)
return number is
  rc number(5);
begin
  select count(*) into rc from subject where pulpit = pcode;
  return rc;
end;

end;

--7. Разработайте анонимный блок и продемонстрируйте выполнение процедур и функций пакета TEACHERS.

declare
  r teachers.rec;
begin
  r.fcode := 'ИЭФ';
  r.pcode := 'ИСиТ';
  teachers.get_teachers_fac(r.fcode);
  dbms_output.put_line(teachers.get_num_teachers_fac(r.fcode));
  teachers.get_subjects(r.pcode);
  dbms_output.put_line(teachers.get_num_subjects(r.pcode));
end;
