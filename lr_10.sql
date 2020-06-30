--1.	Разработайте простейший анонимный блок PL/SQL (АБ), не содержащий операторов.

begin
  null;
end;

--2.	Разработайте АБ, выводящий «Hello World!». Выполните его в SQLDev и SQL+.

begin
  dbms_output.put_line('Hello World!');
end;

--3.	Продемонстрируйте работу исключения и встроенных функций sqlerrm, sqlcode.

declare
  x number(10,2);
begin
  x := 3/0;
exception
  when others
  then dbms_output.put_line('error'||sqlcode||' = '||sqlerrm);
end;

--4.	Разработайте вложенный блок. Продемонстрируйте принцип обработки исключений во вложенных блоках.

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

--5.	Выясните, какие типы предупреждения компилятора поддерживаются в данный момент.

select dbms_warning.get_warning_setting_string from dual;

--6.	Разработайте скрипт, позволяющий просмотреть все спецсимволы PL/SQL.

connect sys as sysdba/1234;
select keyword from v_$reserved_words where length = 1 and keyword != 'A';

--7.	Разработайте скрипт, позволяющий просмотреть все ключевые слова  PL/SQL.

connect sys as sysdba/1234;
select keyword from v_$reserved_words where length > 1 and keyword != 'A' order by keyword;

--8.	Разработайте скрипт, позволяющий просмотреть все параметры Oracle Server, связанные с PL/SQL. Просмотрите эти же параметры с помощью SQL+-команды show.
--9.	Разработайте анонимный блок, демонстрирующий (выводящий в выходной серверный поток результаты):
--объявление и инициализацию целых number-переменных;
--арифметические действия над двумя целыми number-переменных, включая деление с остатком;
--объявление и инициализацию number-переменных с фиксированной точкой;
--объявление и инициализацию number-переменных с фиксированной точкой и отрицательным масштабом (округление);
--объявление и инициализацию BINARY_FLOAT-переменной;
--объявление и инициализацию BINARY_DOUBLE-переменной;
--объявление number-переменных с точкой и применением символа E (степень 10) при инициализации/присвоении;
--объявление и инициализацию BOOLEAN-переменных. 

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

--18.	Разработайте анонимный блок PL/SQL содержащий объявление констант (VARCHAR2, CHAR, NUMBER). Продемонстрируйте  возможные операции константами. 

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

--19.	Разработайте АБ, содержащий объявления с опцией %TYPE. Продемонстрируйте действие опции.
--20.	Разработайте АБ, содержащий объявления с опцией %ROWTYPE. Продемонстрируйте действие опции.

declare
  subject MYS.subject.subject%type;
  pulpit MYS.pulpit.pulpit%type;
  faculty_rec MYS.faculty%rowtype;
begin
  subject := 'ПИС';
  pulpit := 'ИСиТ';
  faculty_rec.faculty := 'ИДиП';
  faculty_rec.faculty_name := 'Факультет издательского дела и полиграфии';
  dbms_output.put_line(subject);
  dbms_output.put_line(pulpit);
  dbms_output.put_line(rtrim(faculty_rec.faculty)||' : '||faculty_rec.faculty_name);
  exception
    when others
      then dbms_output.put_line('error'||sqlcode||' = '||sqlerrm);
end;

--21.	Разработайте АБ, демонстрирующий все возможные конструкции оператора IF .

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

--23.	Разработайте АБ, демонстрирующий работу оператора CASE.

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

--24.	Разработайте АБ, демонстрирующий работу оператора LOOP.
--25.	Разработайте АБ, демонстрирующий работу оператора WHILE.
--26.	Разработайте АБ, демонстрирующий работу оператора FOR.

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
