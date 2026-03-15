----Measuring Customer Loyality

---ONLY 580 customers perform sale out of 1000

----Repeat Purchase Behaviour
create or replace view repeated_customers as(
	SELECT 
	    COUNT(*) AS Repeated_customers,ROUND(COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT customer_id) FROM sales),2) 
	    AS Repeat_Purchase_perc
	FROM (
	    SELECT customer_id
	    FROM sales
	    GROUP BY customer_id
	    HAVING COUNT(sale_id) >= 2
	) 
)
---41% Repeat Purchase Behaviour 
---59% one time buyer behaviour


--Retention Rate / Churn rate
create or REPLACE view cust_category as (
	SELECT 
	    customer_id,
	    EXTRACT(MONTH FROM first_purchase_date) AS first_purchase_month,
	    EXTRACT(MONTH FROM last_purchase_date) AS last_purchase_month,
	    CASE 
	        WHEN EXTRACT(MONTH FROM last_purchase_date) = 4 THEN 'Churned'
			WHEN EXTRACT(MONTH FROM last_purchase_date) = 5 AND EXTRACT(MONTH FROM first_purchase_date)<=5  THEN 'Risky'
			WHEN EXTRACT(MONTH FROM last_purchase_date) = 6 THEN 'Active'
	    END AS category,
		total_sales
	FROM(
	    SELECT 
	        c.customer_id,
	        MIN(s.sale_date) AS first_purchase_date,
	        MAX(s.sale_date) AS last_purchase_date,
	        COUNT(s.sale_id) AS total_sales
	    FROM customers c 
	    JOIN sales s
	    ON s.customer_id = c.customer_id
	    GROUP BY c.customer_id
	) 
)

SELECT 
    category,
    COUNT(*) AS no_customers,
    ROUND(
        COUNT(*) * 100 / 
        (SELECT COUNT(DISTINCT customer_id) FROM cust_category)
    ,2) AS rate
FROM cust_category
GROUP BY category;

---“Overall customers include 22% Active, 47% At‑risk, 30% Churned customers.”.



----CLV (average revenue per customer * average lifespan) It is appropriate pr Large time span like years , not suitable here because we have only 3 months

-- WITH revenue_per_cust as (
--   SELECT
--         SUM(s.total_amount) AS total_revenue,
--         COUNT(DISTINCT s.customer_id) AS total_customers,  SUM(s.total_amount)/ COUNT(DISTINCT s.customer_id)  as avg_revenue_per_customer,
--         (SELECT COUNT(DISTINCT DATE_TRUNC('month', sale_date)) AS total_months
-- 		FROM sales)
--     FROM sales s
-- ),
-- avg_lifespan as (
-- SELECT 
--     round(AVG((last_purchase - first_purchase)) / 30.0,2) AS avg_lifespan_months
-- FROM (
--     SELECT 
--         customer_id,
--         MIN(sale_date) AS first_purchase,
--         MAX(sale_date) AS last_purchase
--     FROM sales
--     GROUP BY customer_id
-- ) AS customer_dates
-- )

-- SELECT 
--     r.avg_revenue_per_customer,
--     a.avg_lifespan_months ,
--     ROUND(r.avg_revenue_per_customer * r.total_months, 2) AS CLV
-- FROM revenue_per_cust r CROSS JOIN avg_lifespan a;

-- ----CLV is 1677


-----Customer segmentation using RFM
create or replace view customer_segmentation as (
with RFM as (
	select customer_id, (select max(sale_date) as last_date from sales )-max(sale_date) as recency,
	count(sale_id) as frequency,
	sum(total_amount) as monetary
	from sales
	group by customer_id
),
scores as (
	select 
		customer_id,
		NTILE(3) OVER (ORDER BY recency) as r_score,---R
		NTILE(3) OVER (ORDER BY frequency DESC) as f_score,---F
		NTILE(3) OVER (ORDER BY monetary DESC) as m_score---M
	from RFM
)


select customer_id,
case 
	WHEN r_score =1 AND f_score =1 AND m_score=1 THEN 'High_value'
	WHEN r_score =3 AND f_score =3 AND m_score=3 THEN 'Low'
	ELSE 'Medium'
end as Segments
from scores
)

select Segments,count (*)
from customer_segmentation
group by Segments
--90 High value customers
--424 medium customers


SELECT customer_id, Segments
from customer_segmentation 
where Segments='High_value' 

----30 High-value customers are at risk (purchased in May)
----60 High-value customers are  Active (purchased in June)

--“A significant share of high‑value customers are currently at‑risk, as they haven’t purchased in the latest month, making them a critical segment for targeted win‑back campaigns before they churn.”
--“Active customers have purchased in the most recent month and form the current backbone of revenue, so consistent engagement and reinforcement offers are needed to keep them loyal and gradually move more of them into the high‑value tier.”



SELECT 
  cc.category,      -- Active / Risky / Churned
  cs.segments,      -- Medium
  COUNT(*) 
FROM customer_segmentation cs
JOIN cust_category cc 
  ON cc.customer_id = cs.customer_id
WHERE cs.segments = 'Medium'
GROUP BY cc.category, cs.segments;
---68 Medium customers are active

--“Most of our customers fall into the Medium segment, indicating a large base of moderately engaged buyers with potential to be upgraded to High_value through targeted promotions.”
--“Medium customers who are still Active should be prioritized for cross‑sell and loyalty offers, while Medium‑Risky customers need gentle win‑back nudges to prevent future churn.”
