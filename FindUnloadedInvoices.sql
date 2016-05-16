set serveroutput on; 
set verify off; 

-- using sql plus for this varible 
accept company_no prompt "Company Number: ";
 

/*  Starting PL/SQL+ script to get table_name */ 

declare 
	company_no number(2) := &company_no;
-- 	company_no number(2) := &company_no;
	table_name varchar(20);

begin
 
	dbms_output.put_line('LooKing for Company Table Name...&company_no');
	
if 
	company_no = 8 
then 
	table_name := 'whse_ship_typhoon';

elsif
	company_no = 12 
then 
	table_name := 'whse_ship_orders';
elsif
	company_no = 9 
then 
	table_name := 'whse_ship_vigar';

elsif
	company_no = 6 
then 
	table_name := 'whse_ship_tvs';

elsif
	company_no = 12 
then 
	table_name := 'whse_ship_orders';

elsif
	company_no = 40
then 
	table_name := 'whse_ship_mb';
end if;

dbms_output.put_line('Company: &company_no is &table_name');

end; 
/

/* 
accept invoice_no prompt "Invoice Number: ";

declare 
	invoice_no number(10); 
begin 
	if invoice_no = NULL then 
		invoice_no := 8122; 
	end if; 

dbms_output.put_line('Invoice Number is: &invoice_no'); 

end; 
/

*/

select 'Describe Table:' from dual;
desc &table_name; 

select 'Unloaded Invoices:' from dual;

select distinct INVOICE_NUMBER from &table_name 
where comp_no = &company_no and is_processed = 'F'
group by invoice_number;

/*  Only apply these after some conditional checks 
-- delete from &table_name where comp_no = &company_no and is_processed = 'F' 
--	or invoice_number = &invoice_no and comp_no = &company_no and is_processed = 'F'  ; 
*/ 

