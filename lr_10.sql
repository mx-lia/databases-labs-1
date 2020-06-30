--1.	������������ ���������� ��������� ���� PL/SQL (��), �� ���������� ����������.

begin
  null;
end;

--2.	������������ ��, ��������� �Hello World!�. ��������� ��� � SQLDev � SQL+.

begin
  dbms_output.put_line('Hello World!');
end;

--3.	����������������� ������ ���������� � ���������� ������� sqlerrm, sqlcode.

declare
  x number(10,2);
begin
  x := 3/0;
exception
  when others
  then dbms_output.put_line('error'||sqlcode||' = '||sqlerrm);
end;

--4.	������������ ��������� ����. ����������������� ������� ��������� ���������� �� ��������� ������.

declare
  z number(10, 2);
begin
  dbms_output.put_line('Outside block');
  begin
    z := 1/0;
  exception
    when others
    then dbms_output.put_line('error'||sqlcode||' = '||sqlerrm);
  end;
  dbms_output.put_line('z = '||z);
end;

--5.	��������, ����� ���� �������������� ����������� �������������� � ������ ������.

select dbms_warning.get_warning_setting_string from dual;

--6.	������������ ������, ����������� ����������� ��� ����������� PL/SQL.

connect sys as sysdba/1234;
select keyword from v_$reserved_words where length = 1 and keyword != 'A';

--7.	������������ ������, ����������� ����������� ��� �������� �����  PL/SQL.

connect sys as sysdba/1234;
select keyword from v_$reserved_words where length > 1 and keyword != 'A' order by keyword;

--8.	������������ ������, ����������� ����������� ��� ��������� Oracle Server, ��������� � PL/SQL. ����������� ��� �� ��������� � ������� SQL+-������� show.
--9.	������������ ��������� ����, ��������������� (��������� � �������� ��������� ����� ����������):
--���������� � ������������� ����� number-����������;
--�������������� �������� ��� ����� ������ number-����������, ������� ������� � ��������;
--���������� � ������������� number-���������� � ������������� ������;
--���������� � ������������� number-���������� � ������������� ������ � ������������� ��������� (����������);
--���������� � ������������� BINARY_FLOAT-����������;
--���������� � ������������� BINARY_DOUBLE-����������;
--���������� number-���������� � ������ � ����������� ������� E (������� 10) ��� �������������/����������;
--���������� � ������������� BOOLEAN-����������. 

declare
  n1 number := 20;
  n2 number(2) := 10;
  n3 number(4, 2) := 2.43;
  n4 number(4, -2) := 3000;
  n5 number(4, 2) := 4788E-2;
  f binary_float := 13213.432432;
  d binary_double := 321432425435.45435345;
  b1 boolean := true;
  b2 boolean := false;
begin
  dbms_output.put_line('n1 + n2 = '||(n1 + n2));
  dbms_output.put_line('n1 - n2 = '||(n1 - n2));
  dbms_output.put_line('n1 * n2 = '||(n1 * n2));
  dbms_output.put_line('n1 / n2 = '||(n1 / n2));
end;

--18.	������������ ��������� ���� PL/SQL ���������� ���������� �������� (VARCHAR2, CHAR, NUMBER). �����������������  ��������� �������� �����������. 

declare
  n1 constant number(5) := 5;
  c1 constant char := 'D';
  v1 constant varchar2(3) := 'ABC';
begin
  n1 := 10;
  exception
    when others
    then dbms_output.put_line('error'||sqlcode||' = '||sqlerrm);
end;

--19.	������������ ��, ���������� ���������� � ������ %TYPE. ����������������� �������� �����.
--20.	������������ ��, ���������� ���������� � ������ %ROWTYPE. ����������������� �������� �����.

declare
  subject MYS.subject.subject%type;
  pulpit MYS.pulpit.pulpit%type;
  faculty_rec MYS.faculty%rowtype;
begin
  subject := '���';
  pulpit := '����';
  faculty_rec.faculty := '����';
  faculty_rec.faculty_name := '��������� ������������� ���� � ����������';
  dbms_output.put_line(subject);
  dbms_output.put_line(pulpit);
  dbms_output.put_line(rtrim(faculty_rec.faculty)||' : '||faculty_rec.faculty_name);
  exception
    when others
      then dbms_output.put_line('error'||sqlcode||' = '||sqlerrm);
end;

--21.	������������ ��, ��������������� ��� ��������� ����������� ��������� IF .

declare
  x pls_integer := 17;
begin
  if 8 > x
  then
    dbms_output.put_line('8 > '||x);
  end if;
----------------------
  if 8 > x
  then
    dbms_output.put_line('8 > '||x);
  else
    dbms_output.put_line('8 <= '||x);
  end if;
--------------------
  if 8 > x
  then
    dbms_output.put_line('8 > '||x);
  elsif 8 = x
  then
    dbms_output.put_line('8 = '||x);
  elsif 12 > x
  then
    dbms_output.put_line('12 > '||x);
  elsif 12 = x
  then
    dbms_output.put_line('12 = '||x);
  else
    dbms_output.put_line('12 < '||x);
  end if;
end;

--23.	������������ ��, ��������������� ������ ��������� CASE.

declare
  x pls_integer := 17;
begin
  case x
    when 1 then dbms_output.put_line('1');
    when 2 then dbms_output.put_line('2');
    when 3 then dbms_output.put_line('3');
    else dbms_output.put_line('else');
  end case;
---------------------
  case 
    when 8 > x then dbms_output.put_line('8 > '||x);
    when 8 = x then dbms_output.put_line('8 = '||x);
    when 12 = x then dbms_output.put_line('12 = '||x);
    when x between 13 and 20 then dbms_output.put_line('13 <= '||x||' <= 20');
    else dbms_output.put_line('else');
  end case;
end;

--24.	������������ ��, ��������������� ������ ��������� LOOP.
--25.	������������ ��, ��������������� ������ ��������� WHILE.
--26.	������������ ��, ��������������� ������ ��������� FOR.

declare
  x pls_integer := 0;
begin
---------------------
  loop
    x := x + 1;
    dbms_output.put_line(x);
  exit when x > 5;
  end loop;
--------------------
  for k in 1..5
  loop
    dbms_output.put_line(k);
  end loop;
-------------------
  while (x > 0)
  loop
    x := x - 1;
    dbms_output.put_line(x);
  end loop;
end;
