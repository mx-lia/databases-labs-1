--1.	���������� ������� ��������� � ������� ������ ������������ ����������� �����.

grant create sequence,
      create synonym,
      create public synonym,
      create view,
      create materialized view,
      create cluster to u1_mys_pdb;

--2.	�������� ������������������ S1 (SEQUENCE), �� ���������� ����������������: ��������� �������� 1000; ���������� 10;
--��� ������������ ��������; ��� ������������� ��������; �� �����������; �������� �� ���������� � ������; ���������� �������� �� �������������.
--�������� ��������� �������� ������������������. �������� ������� �������� ������������������.

create sequence S1
increment by 10
start with 1000
nomaxvalue
nominvalue
nocycle
nocache
noorder;

select S1.nextval from dual;
select S1.currval from dual;

--3.	�������� ������������������ S2 (SEQUENCE), �� ���������� ����������������: ��������� �������� 10; ���������� 10; ������������ �������� 100; 
--�� �����������. �������� ��� �������� ������������������. ����������� �������� ��������, ��������� �� ������������ ��������.

create sequence S2
increment by 10
start with 10
maxvalue 100
nominvalue
nocycle
nocache
noorder;

select S2.nextval from dual;
select S2.currval from dual;

--5.	�������� ������������������ S3 (SEQUENCE), �� ���������� ����������������: ��������� �������� 10; ���������� -10;
--����������� �������� -100; �� �����������; ������������� ���������� ��������. �������� ��� �������� ������������������. ����������� �������� ��������, ������ ������������ ��������.

create sequence S3
increment by -10
nomaxvalue
minvalue -100
start with -10
nocycle
nocache
order;

select S3.nextval from dual;
select S3.currval from dual;

--6.	�������� ������������������ S4 (SEQUENCE), �� ���������� ����������������: ��������� �������� 1; ���������� 1; ����������� �������� 10;
--�����������; ���������� � ������ 5 ��������; ���������� �������� �� �������������. ����������������� ����������� ��������� �������� ������������������� S4.

create sequence S4
increment by 1
maxvalue 10
nominvalue
start with 1
cycle
cache 5
noorder;

select S4.nextval from dual;
select S4.currval from dual;

--7.	�������� ������ ���� ������������������� � ������� ���� ������, ���������� ������� �������� ������������ XXX.

select * from sys.user_sequences;

--8.	�������� ������� T1, ������� ������� N1, N2, N3, N4, ���� NUMBER (20), ���������� � ������������� � �������� ���� KEEP.
--� ������� ��������� INSERT �������� 7 �����, �������� �������� ��� �������� ������ ������������� � ������� ������������������� S1, S2, S3, S4.

create table T1 
(
  N1 number(20),
  N2 number(20),
  N3 number(20),
  N4 number(20)
) storage (buffer_pool keep) cache;

insert into T1(N1, N2, N3, N4) values (S1.nextval, S2.nextval, S3.nextval, S4.nextval);

select * from T1;

--9.	�������� ������� ABC, ������� hash-��� (������ 200) � ���������� 2 ����: X (NUMBER (10)), V (VARCHAR2(12)).

create cluster ABC
(
  X number(10),
  V varchar2(12)
) hashkeys 200;

--10.	�������� ������� A, ������� ������� XA (NUMBER (10)) � VA (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������.

create table A
(
  XA number(10),
  VA varchar2(12),
  RA number(10)
) cluster ABC(XA, VA);

--11.	�������� ������� B, ������� ������� XB (NUMBER (10)) � VB (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������.

create table B
(
  XB number(10),
  VB varchar2(12),
  RB number(10)
) cluster ABC(XB, VB);

--12.	�������� ������� �, ������� ������� X� (NUMBER (10)) � V� (VARCHAR2(12)), ������������� �������� ABC, � ����� ��� ���� ������������ �������. 

create table C
(
  XC number(10),
  VC varchar2(12),
  RC number(10)
) cluster ABC(XC, VC);

--13.	������� ��������� ������� � ������� � �������������� ������� Oracle.

select * from user_clusters;
select * from user_tables;

--14.	�������� ������� ������� ��� ������� XXX.� � ����������������� ��� ����������.

create synonym u1_c for C;
select * from u1_c;

--15.	�������� ��������� ������� ��� ������� XXX.B � ����������������� ��� ����������.

create public synonym u1_b for B;
select * from u1_b;

--16.	�������� ��� ������������ ������� A � B (� ��������� � ������� �������), ��������� �� �������, �������� ������������� V1, ���������� �� SELECT... FOR A inner join B.
--����������������� ��� �����������������.

create table A1
(
  A1_ID int primary key,
  A1_test varchar(10)
);

create table B1
(
  B1_ID int primary key,
  B1_test varchar(10),
  A1_ID int,
  constraint fk_ID foreign key (A1_ID) references A1(A1_ID)
);

insert into A1(A1_ID, A1_test) values (1, 'test');
insert into A1(A1_ID, A1_test) values (2, 'test');
insert into A1(A1_ID, A1_test) values (3, 'test');

insert into B1(B1_ID, B1_test, A1_ID) values (1, 'test', 1);
insert into B1(B1_ID, B1_test, A1_ID) values (2, 'test', 3);

create view V1 as select A1.A1_ID, A1.A1_test, B1.B1_ID, B1.B1_test from A1 inner join B1 on A1.A1_ID = B1.B1_ID;
select * from V1;

--17.	�� ������ ������ A � B �������� ����������������� ������������� MV, ������� ����� ������������� ���������� 2 ������. ����������������� ��� �����������������.

create materialized view VM
build immediate
refresh complete
start with (sysdate) next (sysdate+2/1440) with rowid as select A1.A1_ID, A1.A1_test, B1.B1_ID, B1.B1_test from A1 inner join B1 on A1.A1_ID = B1.B1_ID;

select * from VM;