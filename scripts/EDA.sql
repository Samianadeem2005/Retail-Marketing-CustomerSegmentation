select * from campaigns;

---EDA

---Exploring channels
select channel , count(distinct channel) ---there are 5 channels
from channels
group by channel;


--Exploring campaigns
select campaign_name , count(distinct campaign_name)
from campaigns
group by campaign_name;

--total campaign
select count(distinct campaign_name) as total_campaigns from campaigns;-- there are 7 campaigns


---Joined campaigns and channels table as a view
create or replace view marketing as (
	select c.* , ch.description
	from campaigns c join channels ch
	on c.channel= ch.channel
	order by campaign_id);


SELECT campaign_name,
       start_date,
       end_date,
       end_date - start_date AS campaign_duration_days----max campaign days are 11(TIVA week), min are 6(Spring Flash Sale)
FROM marketing
order by ( end_date - start_date) desc;


---Total customers  
select count(distinct customer_id) as total_custs from customers; ---total customers are 1000


---Total customers by country 
select country, count(customer_id) --- we have 6 countries, France , Germany & Italy have most customers 
from customers
group by country
order by count(distinct customer_id) desc;----least customers are in portugal


---Exploring products
select category,brand, count(distinct product_id)----we have only 1 brand named "Tiva"
from products
group by category, brand
order by count(distinct product_id) desc; 


select count(distinct product_id) as total_products from products;--- we have 500 products
select count(distinct category) as total_categories from products;--- we have 5 categories



---Creating a view by joing Products and Stock table
create or replace view Product_stock as (
	select p.*, s.country, s.stock_quantity
	from products p left join stock s on p.product_id = s.product_id
);


----Sales by country wise
select country, count(sale_id ) as total_sales ---most sales are from Germany & France bcz they have most customers
from sales
group by country
order by count(sale_id ) desc;



----Sales brought by channels country wise
select country,channel, count(sale_id ) as total_sales ---most sales are from Germany & France bcz they have most customers
from sales
group by country, channel
order by count(sale_id ) desc;


---TOP 10 Customers by Max orders
select customer_id, count(sale_id)---cust_id 99 has placed max of 7 orders
from sales
group by customer_id order by count(sale_id) desc limit 10;


-----Checking max price for any item
select MAX(original_price)-----85.90
from sales_items;


---Checking Sale Time period 
SELECT TO_CHAR(sale_date, 'Month'), EXTRACT('year' from sale_date) AS month_name----Sale is between April , May & June 2025
FROM sales
GROUP BY TO_CHAR(sale_date, 'Month'), EXTRACT(MONTH FROM sale_date),EXTRACT('year' from sale_date)
ORDER BY EXTRACT(MONTH FROM sale_date);



----which channel is producing more sales
select m.channel, count(s.sale_id ) as total_sales 
from channels m left join sales s  on s.channel= m.channel----E-commerce and App Mobile are the only channels bringing sales
group by m.channel;



----Top 10 revenue makers
select c.customer_id , sum(s.total_amount) 
from customers c join sales s on c.customer_id=s.customer_id
group by c.customer_id
order by sum(s.total_amount) desc limit 10;


---Top 10 products by sales
select  ps.product_id,ps.product_name, count(si.product_id) as no_orders,sum(si.quantity) as total_sales
from product_stock ps  join sales_items si on ps.product_id = si.product_id
group by ps.product_name, ps.product_id
order by sum(si.quantity) desc limit 10;


---Top 10 products by revenue
select ps.product_id, ps.product_name,sum(si.item_total) as total_sales
from product_stock ps  join sales_items si on ps.product_id = si.product_id
group by ps.product_name, ps.product_id
order by sum(si.item_total) desc limit 10;


----Summary Report 
SELECT 'Total Channels' AS metric, COUNT(DISTINCT channel) AS total
FROM channels
UNION ALL
SELECT 'Total Campaigns', COUNT(DISTINCT campaign_name) 
FROM campaigns
UNION ALL
select 'Total Customers',count(distinct customer_id) 
from customers
UNION ALL
select 'Total Customers who purchased', count(distinct customer_id)
from sales
UNION ALL
select 'Total Countries', count(distinct country)
from customers
UNION ALL
select 'Total  products',count(distinct product_id) 
from products
UNION ALL
select 'Total categories',count(distinct category)
from products
UNION ALL
SELECT 'Max campaign days',MAX(end_date - start_date)
FROM marketing
UNION ALL
SELECT 'Min campaign days',MIN(end_date - start_date)
FROM marketing
UNION ALL
SELECT 'Year_of_sale',EXTRACT('year' from sale_date)
from Sales group by EXTRACT('year' from sale_date) 
UNION ALL
select 'Max Original price',MAX(original_price)
from sales_items