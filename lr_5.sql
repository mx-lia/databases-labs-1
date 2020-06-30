--1. Получите список всех файлов табличных пространств (перманентных  и временных).

select t.name "Tablespace", f.name "Datafile" from v$tablespace t, v$datafile f where t.ts# = f.ts# order by t.name;

--2. Создайте табличное пространство с именем XXX_QDATA (10m). При создании установите его в состояние offline.
--Затем переведите табличное пространство в состояние online. Выделите пользователю XXX квоту 2m в пространстве XXX_QDATA. 
--От имени XXX в  пространстве XXX_T1создайте таблицу из двух столбцов, один из которых будет являться первичным ключом. В таблицу добавьте 3 строки.

create tablespace mys_qdata
  datafile 'D:\Study\Databases\mys_data.dbf'
  size 10 m
  offline;
  
alter tablespace mys_qdata online;

alter session set "_ORACLE_SCRIPT" = true;

alter user mys identified by 1234
default tablespace mys_qdata
quota 2m on mys_qdata;

grant create table,
      drop any table to mys;

connect mys/1234;
create table mys_t1
(
  id_t1 int primary key,
  name_t1 varchar(10)
);

insert into mys_t1(id_t1, name_t1) values (1, 'test1');
insert into mys_t1(id_t1, name_t1) values (2, 'test2');
insert into mys_t1(id_t1, name_t1) values (3, 'test3');

--3. Получите список сегментов табличного пространства  XXX_QDATA. Определите сегмент таблицы XXX_T1. Определите остальные сегменты.

select * from dba_segments where tablespace_name = 'MYS_QDATA';

--4. Удалите (DROP) таблицу XXX_T1. Получите список сегментов табличного пространства  XXX_QDATA. Определите сегмент таблицы XXX_T1. 
--Выполните SELECT-запрос к представлению USER_RECYCLEBIN, поясните результат.

connect mys/1234;
drop table mys_t1;

select * from dba_segments where tablespace_name = 'MYS_QDATA';
select * from user_recyclebin;

--5. Восстановите (FLASHBACK) удаленную таблицу. 

connect mys/1234;
flashback table mys_t1 to before drop;

--6. Выполните PL/SQL-скрипт, заполняющий таблицу XXX_T1 данными (10000 строк). 

connect mys/1234;
begin
delete from mys_t1;
for k in 1..10000
loop
  insert into mys_t1(id_t1, name_t1) values (k, 'test');
end loop;
commit;
end;

--7. Определите сколько в сегменте таблицы XXX_T1 экстентов, их размер в блоках и байтах. Получите перечень всех экстентов. 

select segment_name, segment_type, tablespace_name, bytes, blocks, extents, buffer_pool from dba_segments where tablespace_name = 'MYS_QDATA';
select * from dba_extents where tablespace_name = 'MYS_QDATA';

--8. Удалите табличное пространство XXX_QDATA и его файл. 

drop tablespace MYS_QDATA including contents and datafiles;

--9. Получите перечень всех групп журналов повтора. Определите текущую группу журналов повтора.

select * from v$logfile;
select group#, status, members from v$log;

--10. Получите перечень файлов всех журналов повтора инстанса.



--11. EX. С помощью переключения журналов повтора пройдите полный цикл переключений. 
--Запишите серверное время в момент вашего первого переключения (оно понадобится для выполнения следующих заданий).

alter system switch logfile; --19.06
select group#, status, members from v$log;

--12. EX. Создайте дополнительную группу журналов повтора с тремя файлами журнала. 
--Убедитесь в наличии группы и файлов, а также в работоспособности группы (переключением). Проследите последовательность SCN. 

alter database add logfile group 4 'C:\APP\ORACLE\ORADATA\ORCL\REDO04.LOG'
size 50m blocksize 512;

select * from v$log;

alter database add logfile member 'C:\APP\ORACLE\ORADATA\ORCL\REDO041.LOG' to group 4;
alter database add logfile member 'C:\APP\ORACLE\ORADATA\ORCL\REDO042.LOG' to group 4;

select * from v$log;

--13. EX. Удалите созданную группу журналов повтора. Удалите созданные вами файлы журналов на сервере.

alter database drop logfile member 'C:\APP\ORACLE\ORADATA\ORCL\REDO041.LOG';
alter database drop logfile member 'C:\APP\ORACLE\ORADATA\ORCL\REDO042.LOG';

alter database drop logfile group 4;

select * from v$log;

--14. Определите, выполняется или нет архивирование журналов повтора (архивирование должно быть отключено, 
--иначе дождитесь, пока другой студент выполнит задание и отключит).

select name, log_mode from v$database;

--15. Определите номер последнего архива.  
--16. EX.  Включите архивирование. 

select name, log_mode from v$database;

--17. EX. Принудительно создайте архивный файл. Определите его номер. Определите его местоположение и убедитесь в его наличии. 
--Проследите последовательность SCN в архивах и журналах повтора. 

select instance_name, archiver, active_state from v$instance;
select * from v$log;
select * from v$archived_log;
archive log list;
show parameter db_recovery;

--18. EX. Отключите архивирование. Убедитесь, что архивирование отключено.  

select instance_name, archiver, active_state from v$instance;

--19. Получите список управляющих файлов.

select * from v$controlfile;

--20. Получите и исследуйте содержимое управляющего файла. Поясните известные вам параметры в файле.

--21. Определите местоположение файла параметров инстанса. Убедитесь в наличии этого файла. 

select name, value from v$parameter where name = 'open_cursors';

--22. Сформируйте PFILE с именем XXX_PFILE.ORA. Исследуйте его содержимое. Поясните известные вам параметры в файле.

create pfile = 'p1.ora' from spfile;

--23. Определите местоположение файла паролей инстанса. Убедитесь в наличии этого файла. 

select * from v$pwfile_users;

--24. Получите перечень директориев для файлов сообщений и диагностики. 

select * from v$diag_info;

--25. EX. Найдите и исследуйте содержимое протокола работы инстанса (LOG.XML), найдите в нем команды переключения журналов которые вы выполняли.
