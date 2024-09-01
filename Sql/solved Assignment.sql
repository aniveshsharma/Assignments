-- 1. In how many states has the business served? (Get the distinct number of states)

select count(distinct state) from customers;

-- 2 .Who is the most frequent customer? (Get the customer id,name and state and number or
-- orders placed of the most frequent top 3 customer)

select c.customer_id, concat(c.firstname, " ", c.lastname) as Name, c.state, count(s.customer_id) as Number_of_orders from 
customers c
join
sales_data s
on c.customer_id=s.customer_id
group by s.customer_id
order by Number_of_orders desc
limit 3;

-- 3. Get the category_id of the highest selling CATEGORY

select p.category_id,c.category_name, sum(s.sales) as Sales from 
products as p
join
sales_data s
on p.product_id=s.product_id
join
categories c
on p.category_id=c.category_id
group by p.category_id
order by Sales desc;


select p.category_id,c.category_name, sum(s.quantities) as Quantity from 
products as p
join
sales_data s
on p.product_id=s.product_id
join
categories c
on p.category_id=c.category_id
group by p.category_id
order by Quantity desc;



-- 4. Get monthly sales.

select monthname(date) as Month_name , sum(sales) 
from sales_data
group by Month_name, month(date);


-- 5. Get monthly growth rate as compared to previous month





-- 6. What is the rolling_avg of window 3 throughout the year?


select year(date), sales, 
Avg(sales) over(order by date rows between 2 preceding and current row)as Rollig_avg
from sales_data;




-- 7. Find the top 3 customers in each state. (Get
-- purchase_id,date,customer_id,sales,state,ranks of the top 3 sales)




-- 8. Get the months when the total monthly sales was above the average of overall sales
where Monthly_sales >= avg(sum(sales)
select monthname(date) as Month_name , sum(sales)  as Monthly_sales
from sales_data
group by Month_name, month(date);



-- 9 Which product is in Demand in Delhi? (Get the highest ordered product in delhi)

select c.state,p.product_name,count(s.quantities) as Quantity, 
sum(s.sales) as Sales 
from
customers c
join
sales_data s
on c.customer_id=s.customer_id
join
products p
on s.product_id=p.product_id
where c.state="delhi"
group by s.product_id
order by Quantity desc
limit 5;


-- 10. You are required to check the monthly sales of each state every month. Create a
-- procedure which takes the name of state as input and returns the monthly sales of that state

DROP PROCEDURE IF EXISTS totalsales;


DELIMITER $$
create procedure totalsales(in state varchar(20))
BEGIN
select c.state, sum(s.sales)
from
customers c
join
sales_data s
on c.customer_id=s.customer_id
where c.state=state
group by c.state;
END $$
DELIMITER ;

call totalsales("Assam")