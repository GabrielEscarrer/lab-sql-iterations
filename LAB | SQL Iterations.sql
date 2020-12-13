-- Write a query to find what is the total business done by each store.

select A.store_id, B.sales
from store A
join (
  select cus.store_id, sum(pay.amount) sales
  from customer cus
  join payment pay
  on pay.customer_id = cus.customer_id
group by cus.store_id
) B
on A.store_id = B.store_id
order by a.store_id;

-- Convert the previous query into a stored procedure

drop procedure if exists total_sales;
delimiter //
create procedure total_sales()
begin
  select A.store_id, B.sales
from store A
join (
  select cus.store_id, sum(pay.amount) sales
  from customer cus
  join payment pay
  on pay.customer_id = cus.customer_id
group by cus.store_id
) B
on A.store_id = B.store_id
order by a.store_id;
end;
//
delimiter ;

call total_sales();

-- Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store

drop procedure if exists total_sales;
delimiter //
create procedure total_sales(in param1 int)
begin
  select A.store_id, B.sales
from store A
join (
  select cus.store_id, sum(pay.amount) sales
  from customer cus
  join payment pay
  on pay.customer_id = cus.customer_id
group by cus.store_id
) B
on A.store_id = B.store_id
where a.store_id COLLATE utf8mb4_general_ci = param1;
end;
//
delimiter ;

call total_sales(1);

-- Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). Call the stored procedure and print the results

drop procedure if exists total_sales;

delimiter //
create procedure total_sales(in param1 int, out param2 float)
begin
declare total_Sales_value float default 0.0;
  select B.sales into param2
from store A
join (
  select cus.store_id, sum(pay.amount) sales
  from customer cus
  join payment pay
  on pay.customer_id = cus.customer_id
group by cus.store_id
) B
on A.store_id = B.store_id
where a.store_id COLLATE utf8mb4_general_ci = param1;
end;
//
delimiter ;

call total_sales(1, @x);
select round(@x,1) as Total_sales;

-- In the previous query, add another variable flag. If the total sales value for the store is over 30,000, then label it as green_flag, otherwise label is as red_flag. Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value

drop procedure if exists total_sales;

delimiter //
create procedure total_sales(in param1 int, out param2 float, out param3 varchar(10))
begin
declare total_Sales_value float default 0.0;
declare flag varchar(20) default "";

  select B.sales into total_Sales_value
from store A
join (
  select cus.store_id, sum(pay.amount) sales
  from customer cus
  join payment pay
  on pay.customer_id = cus.customer_id
group by cus.store_id
) B
on A.store_id = B.store_id
where a.store_id COLLATE utf8mb4_general_ci = param1;

if total_Sales_value > 30000 then
	set flag = 'Green Flag';
else
	set flag = 'Red Flag';
end if;
  select total_Sales_value into param2;
  select flag into param3;
end;
//
delimiter ;

call total_sales(1, @x, @y);
select round(@x,1) as Total_sales, @y as Flag;