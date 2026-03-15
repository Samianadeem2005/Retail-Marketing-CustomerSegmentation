---Total_Revenue , Rolling_Revenue & Moving Average
select  
Months,
Total_revenue,
ROUND(SUM(total_revenue) over (order by month_num),2) as rolling_revenue,
ROUND(AVG(total_revenue) over (order by month_num),2) as moving_avg 
from (
	Select TO_CHAR(sale_date, 'Month')as Months, SUM(total_amount) as Total_revenue, EXTRACT(MONTH FROM sale_date) AS month_num
	from sales
	group by  EXTRACT(MONTH FROM sale_date),TO_CHAR(sale_date, 'Month')
)
ORDER BY month_num----Revenue : May > April > June



----checking sales wrt months
SELECT TO_CHAR(sale_date, 'FMMonth') AS Months,COUNT(sale_id) AS total_sales,
ROUND(SUM(total_amount)/COUNT(sale_id),2) AS AOV, 
SUM(total_amount) as Total_Reveneue
FROM sales
GROUP BY EXTRACT(MONTH FROM sale_date), TO_CHAR(sale_date, 'FMMonth')
ORDER BY EXTRACT(MONTH FROM sale_date);
---Sales : May > April > June



----Performance Analysis of Revenue by Months
SELECT 
    Months,
    Current_revenue,
    ROUND(AVG(Current_revenue) OVER (),2) AS avg_revenue,
    ROUND(Current_revenue - AVG(Current_revenue) OVER (),2) AS diff_avg,
    CASE
        WHEN Current_revenue < AVG(Current_revenue) OVER () THEN 'Below avg'
        WHEN Current_revenue > AVG(Current_revenue) OVER () THEN 'Above avg'
        ELSE 'Avg'
    END AS avg_change,
    LAG(Current_revenue) OVER (ORDER BY month_num) AS prv_revenue,
    ROUND(Current_revenue - LAG(Current_revenue) OVER (ORDER BY month_num),2) AS diff_prev,
    CASE
        WHEN Current_revenue > LAG(Current_revenue) OVER (ORDER BY month_num) THEN 'Increase'
        WHEN Current_revenue < LAG(Current_revenue) OVER (ORDER BY month_num) THEN 'Decrease'
        ELSE 'No change'
    END AS pm_change,
	Round(((Current_revenue-LAG(Current_revenue) OVER (ORDER BY month_num))/LAG(Current_revenue) OVER (ORDER BY month_num))*100,2) as per_change
FROM(
    SELECT 
        TO_CHAR(s.sale_date,'FMMonth') AS Months,
        SUM(s.total_amount) AS Current_revenue,
        EXTRACT(MONTH FROM s.sale_date) AS month_num
    FROM sales s
    GROUP BY month_num, Months
) t
ORDER BY t.month_num;

-----Revenue of May increased upto 6% while decreased in June by 65.5%



-------------------------------Contributors of May (BEST MONTH)-------------------
---Chceking the contribution of each category in overall business
select Category,
Total_revenue,
sum(total_revenue) over () as overall_revenue,
ROUND(100.0 *Total_revenue / SUM(Total_revenue) OVER (), 2) AS revenue_share_pct
FROM(
	Select p.Category, SUM(s.total_amount) as Total_revenue
	from sales s join sales_items si on s.sale_id=si.sale_id
	join products p on si.product_id= p.product_id
	group by p.Category
)t
order by revenue_share_pct desc;
----Tshirts =1 (21.5%) , Dresses =2 (21.4%) , Shoes = 3 (21.2%) are bringing the most revenue




----Revenue Trends of May by category
select Months,Category,Total_revenue,
ROUND(100.0 * Total_revenue / SUM(Total_revenue) OVER (PARTITION BY Months), 2) AS share,
DENSE_RANK() over (partition by months order by total_revenue desc) AS rank
FROM(
	Select TO_CHAR(s.sale_date, 'Month')as Months,p.Category, SUM(s.total_amount) as Total_revenue,EXTRACT(MONTH FROM s.sale_date) AS month_num
	from sales s join sales_items si on s.sale_id=si.sale_id
	join products p on si.product_id= p.product_id
	group by  EXTRACT(MONTH FROM s.sale_date),TO_CHAR(s.sale_date, 'Month'),Category
)t
WHERE TRIM(Months) = 'May'
order by  month_num;
----May:  T-shirts= 1, Dresses = 2, T-Shoes = 3
-----Sleepwear & Pants have less sale 



----Revenue Trends of May by country
SELECT Months,
       Country,
       ROUND(100.0 * Total_revenue / SUM(Total_revenue) OVER (PARTITION BY Months),2) AS Share,
       DENSE_RANK() OVER (PARTITION BY Months ORDER BY Total_revenue DESC) AS rank
FROM (
    SELECT 
        TO_CHAR(s.sale_date,'Month') AS Months,
        s.country,
        SUM(s.total_amount) AS Total_revenue,
        EXTRACT(MONTH FROM s.sale_date) AS month_num
    FROM sales s
    JOIN sales_items si ON s.sale_id = si.sale_id
    JOIN products p ON si.product_id = p.product_id
    GROUP BY month_num, Months, s.country
) t
WHERE TRIM(Months) = 'May'
ORDER BY month_num;
---May:  Germany = 1 (23.5%), France = 2 (22.5%), Italy = 3 (20.14%)
-----Netherlands , Spain & Portugal has less sales 



----Revenue Trends on Monthly basis by channel
select Months,Channel,Total_revenue,
DENSE_RANK() over (partition by months order by total_revenue desc) AS rank,
ROUND(100.0 * Total_revenue / SUM(Total_revenue) OVER (PARTITION BY Months),2) AS Share
FROM(
	Select TO_CHAR(s.sale_date, 'Month')as Months,s.Channel, SUM(s.total_amount) as Total_revenue, EXTRACT(MONTH FROM s.sale_date) AS month_num
	from sales s join sales_items si on s.sale_id=si.sale_id
	join products p on si.product_id= p.product_id
	group by  EXTRACT(MONTH FROM s.sale_date),TO_CHAR(s.sale_date, 'Month'),s.Channel
	order by  EXTRACT(MONTH FROM s.sale_date) 
)t
WHERE TRIM(Months) = 'May'
ORDER BY month_num;
---E-commerce = 1 (53.8%) , and App mobile = 2 (46.2%) in all 3 months
---Other channels are not deriving any sales



---Insight:
-----“Our best month (May) was driven by strong T‑shirt & Dresses sales in Germany by 24% and France by 22%, mostly through the E‑commerce (53.8%) & Mobile-App channel (46.2%) .”



--------------------Now checking what is missing in Worst Month (June)-------------
----Revenue Trends of June by category
select Months,Category,Total_revenue,
ROUND(100.0 * Total_revenue / SUM(Total_revenue) OVER (PARTITION BY Months), 2) AS share,
DENSE_RANK() over (partition by months order by total_revenue desc) AS rank
FROM(
	Select TO_CHAR(s.sale_date, 'Month')as Months,p.Category, SUM(s.total_amount) as Total_revenue,EXTRACT(MONTH FROM s.sale_date) AS month_num
	from sales s join sales_items si on s.sale_id=si.sale_id
	join products p on si.product_id= p.product_id
	group by  EXTRACT(MONTH FROM s.sale_date),TO_CHAR(s.sale_date, 'Month'),Category
)t
WHERE TRIM(Months) = 'June'
order by  month_num;
---- Shoes = 1, Dresses =2 , T-shirts= 3
----"Overall T-shirts bring the most revenue , which is noticed to drop down in June, while Shoes sales are increased"



----Revenue Trends of June by country
SELECT Months,
       Country,
       ROUND(100.0 * Total_revenue / SUM(Total_revenue) OVER (PARTITION BY Months),2) AS Share,
       DENSE_RANK() OVER (PARTITION BY Months ORDER BY Total_revenue DESC) AS rank
FROM (
    SELECT 
        TO_CHAR(s.sale_date,'Month') AS Months,
        s.country,
        SUM(s.total_amount) AS Total_revenue,
        EXTRACT(MONTH FROM s.sale_date) AS month_num
    FROM sales s
    JOIN sales_items si ON s.sale_id = si.sale_id
    JOIN products p ON si.product_id = p.product_id
    GROUP BY month_num, Months, s.country
) t
WHERE TRIM(Months) = 'June'
ORDER BY month_num;
----Revenue in Germany are dropped from 23.5% to 22.7%, while in France it increased from 22.5% to 25.3%



----Revenue Trends of June by channel
select Months,Channel,Total_revenue,
DENSE_RANK() over (partition by months order by total_revenue desc) AS rank,
ROUND(100.0 * Total_revenue / SUM(Total_revenue) OVER (PARTITION BY Months),2) AS Share
FROM(
	Select TO_CHAR(s.sale_date, 'Month')as Months,s.Channel, SUM(s.total_amount) as Total_revenue, EXTRACT(MONTH FROM s.sale_date) AS month_num
	from sales s join sales_items si on s.sale_id=si.sale_id
	join products p on si.product_id= p.product_id
	group by  EXTRACT(MONTH FROM s.sale_date),TO_CHAR(s.sale_date, 'Month'),s.Channel
	order by  EXTRACT(MONTH FROM s.sale_date) 
)t
WHERE TRIM(Months) = 'June'
ORDER BY month_num;
---Revenue through E-commerce is dropped from 53.8% to 52.5% , while for App mobile it increased from 46.2% to 47.45%


SELECT
    TO_CHAR(s.sale_date, 'Month')           AS month,
    COUNT(DISTINCT s.sale_id)                  AS sales,
    SUM(si.quantity)                           AS units_sold,
    SUM(s.total_amount)                        AS revenue,
    ROUND(SUM(s.total_amount) * 1.0 / COUNT(DISTINCT s.sale_id), 2)      AS aov
FROM sales s
JOIN sales_items si ON s.sale_id = si.sale_id
GROUP BY  EXTRACT(MONTH FROM s.sale_date) ,TO_CHAR(s.sale_date, 'Month')
ORDER BY EXTRACT(MONTH FROM s.sale_date);


---Insight:
---“Although June shows growth in Shoes category, France market and App channel, total revenue still drops sharply because the decline hits our largest revenue drivers:
---T‑shirts (our top category by overall revenue) fall in June.
---Germany, one of our biggest markets, contributes less in June than in May.
---E‑commerce, our main sales channel, also loses share.
---Gains from smaller segments (Shoes, France, App) are not large enough to offset losses from these core segments.”











