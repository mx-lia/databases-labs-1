create or replace package variant7 as
procedure findemp(par out sys_refcursor);
function findoff(reg in offices.region%type) return SYS_REFCURSOR;
end;

create or replace package body variant7 as
procedure findemp(par out sys_refcursor)
as
begin
    FOR rec IN (SELECT * FROM salesreps where salesreps.empl_num not in (select rep from orders))
    LOOP
    DBMS_OUTPUT.PUT_LINE(rec."NAME");
    END LOOP;
exception 
when others
then
   DBMS_OUTPUT.PUT_LINE('ERROR');
end;

function findoff(reg in offices.region%type)
RETURN SYS_REFCURSOR IS
COUNTSAL SYS_REFCURSOR;
begin
    open COUNTSAL for SELECT * FROM offices where offices.region = reg;
    return COUNTSAL;
exception 
when others
then
   DBMS_OUTPUT.PUT_LINE('ERROR');
end;
end;

declare
v_refcur    SYS_REFCURSOR;
v_office offices.office%type;
v_city offices.city%type;
v_region offices.region%type;
v_mgr offices.mgr%type;
v_target offices.target%type;
v_sales offices.sales%type;
begin
  variant7.findemp(v_refcur);
  v_refcur := variant7.findoff('Western');
  LOOP
        FETCH v_refcur INTO v_office, v_city, v_region, v_mgr, v_target, v_sales;
        EXIT WHEN v_refcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_office || '     ' || v_city || '     ' || v_region);
    END LOOP;
    CLOSE v_refcur;
end;