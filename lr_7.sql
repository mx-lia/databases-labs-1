--1.	Получите полный список фоновых процессов. 

select name, description from v$bgprocess;

--2.	Определите фоновые процессы, которые запущены и работают в настоящий момент.

select name, description from v$bgprocess where paddr != hextoraw('00') order by name;

--3.	Определите, сколько процессов DBWn работает в настоящий момент.

select count(*) from v$bgprocess where paddr != hextoraw('00') and description like '%db writer process%';

--4.	Получите перечень текущих соединений с экземпляром.
--5.	Определите режимы этих соединений.

select username, sid, serial#, server, paddr, status from v$session where username is not null;

--6.	Определите сервисы (точки подключения экземпляра).

select addr, spid, pname from v$process where background is null order by pname;

--7.	Получите известные вам параметры диспетчера и их значений.

show parameter dispatcher;

--8.	Укажите в списке Windows-сервисов сервис, реализующий процесс LISTENER.

--Oracle TNSLSNR Executable

--9.	Получите перечень текущих соединений с инстансом. (dedicated, shared). 

select username, sid, serial#, server, paddr, status from v$session;

--10.	Продемонстрируйте и поясните содержимое файла LISTENER.ORA. 

--C:\app\Oracle\product\12.1.0\dbhome_1\NETWORK\ADMIN

--11.	Запустите утилиту lsnrctl и поясните ее основные команды. 

--C:\app\Oracle\product\12.1.0\dbhome_1\BIN

--12.	Получите список служб инстанса, обслуживаемых процессом LISTENER.

select name, network_name, pdb from v$services;
