--1.	Определите общий размер области SGA.

select sum(value) from v$sga;

--2.	Определите текущие размеры основных пулов SGA.

show parameter sga_target;

--3.	Определите размеры гранулы для каждого пула.

select  component,
        current_size, 
        max_size, 
        last_oper_mode, 
        last_oper_time, 
        granule_size, 
        current_size/granule_size as Ratio
from v$sga_dynamic_components
where current_size > 0;

--4.	Определите объем доступной свободной памяти в SGA.

select (sum(max_size)) - (sum(current_size)) from v$sga_dynamic_components;

--5.	Определите размеры пулов КЕЕP, DEFAULT и RECYCLE буферного кэша.

select component, min_size, current_size from v$sga_dynamic_components where component like '%cache%';

--6.	Создайте таблицу, которая будут помещаться в пул КЕЕP. Продемонстрируйте сегмент таблицы.

connect mys/1234;
create table KKK (k int) storage (buffer_pool keep) tablespace users;

insert into KKK values(1);
commit;

select segment_name, segment_type, tablespace_name, buffer_pool from user_segments 
                                                                where segment_name='KKK';

--7.	Создайте таблицу, которая будут кэшироваться в пуле default. Продемонстрируйте сегмент таблицы.

create table DDD (k int) storage (buffer_pool default) tablespace users;

insert into DDD values(1);
commit;

select segment_name, segment_type, tablespace_name, buffer_pool from user_segments 
                                                                where segment_name='DDD';

--8.	Найдите размер буфера журналов повтора.

show parameter log_buffer;

--9.	Найдите 10 самых больших объектов в разделяемом пуле.

select * from (select pool, name, bytes from v$sgastat where pool = 'shared pool' order by bytes desc)
          where rownum <= 10;

--10.	Найдите размер свободной памяти в большом пуле.

select pool, name, bytes from v$sgastat where pool = 'large pool' and name = 'free memory';

--11.	Получите перечень текущих соединений с инстансом. 

select * from v$session;

--12.	Определите режимы текущих соединений с инстансом (dedicated, shared).

select sid, server from v$session;


