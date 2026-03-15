
----checking campaigns
select TO_CHAR(start_date, 'FMMonth') AS month,campaign_name 
from marketing m 

-----campaigns in April are 2 (Easter Promotion , Spring Flash Sale)
-----campaigns in May are 3 (Mid-season clearance , mothers day , tiva week)
-----campaigns in June are 2 (early summer deal, june price drop)


-----sales in normal days vs campaign days 
SELECT 
Months,
sale_type, 
COUNT(sale_id) AS total_sales,
ROUND(
    COUNT(sale_id) * 100.0 /
    SUM(COUNT(sale_id)) OVER (PARTITION BY month_num),2
) AS sales_share_pct
FROM(
    SELECT 
        s.sale_id,campaign_name,
        EXTRACT(MONTH FROM s.sale_date) AS month_num,
        TO_CHAR(s.sale_date,'FMMonth') AS Months,
        CASE 
            WHEN m.campaign_id IS NOT NULL THEN 'Campaign_sales'
            ELSE 'Normal_sales'
        END AS sale_type
    FROM sales s
    LEFT JOIN marketing m
    ON s.channel = m.channel
    AND s.sale_date BETWEEN m.start_date AND m.end_date
) t
GROUP BY month_num, Months, sale_type
ORDER BY month_num, sale_type;
----There were no sales in April & June in campaign days
----May got 63 sales during campaigns



---checking which campaignsales per month deriving sales
WITH may_campaign AS (
    SELECT 
        s.sale_id,
        s.country,
        m.campaign_name,
        TO_CHAR(m.start_date, 'FMMonth') AS month
    FROM sales s
    JOIN marketing m 
        ON s.channel = m.channel
        AND s.sale_date BETWEEN m.start_date AND m.end_date
),
sale_with_category AS (
    SELECT DISTINCT
        mc.sale_id,
        mc.country,
        mc.campaign_name,
        mc.month,
        p.category
    FROM may_campaign mc
    JOIN sales_items si 
        ON mc.sale_id = si.sale_id
    JOIN products p
        ON si.product_id = p.product_id
)
SELECT 
    month,
    country,
    campaign_name,
    category,
    COUNT(sale_id) AS total_sales,
    -- Total sales per country (ignore category duplicates)
    (SELECT COUNT(DISTINCT sale_id) 
     FROM may_campaign mc2 
     WHERE mc2.country = swc.country) AS total_country_sales
FROM sale_with_category swc
GROUP BY month, country, campaign_name, category
ORDER BY country, total_sales DESC;
----only Mid-season clearance is deriving sales



-------Comparing discount during campaign & without campaign
with camp_sale_type as (
	select si.product_id, m.campaign_name, si.discounted,m.discount_type,
	m.discount_value, si.discount_percent, m.start_date, m.end_date, s.sale_date
	from sales s join sales_items si on s.sale_id = si.sale_id
	left join marketing m on si.channel=m.channel 
)

select count(*) from camp_sale_type
-- select * from camp_sale_type
where discounted = 1
-- AND sale_date BETWEEN start_date AND end_date
-- and campaign_name = 'Mid-Season Clearance'
and campaign_name is null

------222 Items are discounted items
------63 items where 10% discount is applied without campaign
------159 items discounted during campaign (obv in May)
----Mid-Season clearance campaign discounted 30% to every product


----Checking which channel brings High value and medium customers
SELECT
    m.channel,
    cs.segments,
	cc.category,
    COUNT(DISTINCT s.customer_id) AS customers,
    SUM(s.total_amount) AS revenue
FROM sales s
JOIN marketing m
  ON s.channel = m.channel
 AND s.sale_date BETWEEN m.start_date AND m.end_date
JOIN customer_segmentation cs
  ON cs.customer_id = s.customer_id
JOIN cust_category cc ON cc.customer_id = cs.customer_id
GROUP BY   m.channel,cs.segments,cc.category
ORDER BY   m.channel,cs.segments,cc.category;
----Through Campaign we have 5 high-value customers  who are active 
----Through Campaign we have 6 high-value customers  who are risky
----Through Campaign we have 1 medium customers  who is active
----Through Campaign we have 49 medium customers  who are active
----Moreover only App mobile brings us high value and medium customers


-----Checking the High value and Medium customers category preferences
SELECT
    cc.category,              -- Active / Risky / Churned
    cs.segments,              -- High_value / Medium / Low
    p.category AS product_category,
    COUNT(DISTINCT s.customer_id) AS customers,
    SUM(s.total_amount) AS revenue
FROM sales s
JOIN customer_segmentation cs
  ON cs.customer_id = s.customer_id
JOIN cust_category cc
  ON cc.customer_id = cs.customer_id
JOIN sales_items si
  ON s.sale_id = si.sale_id
JOIN products p
  ON si.product_id = p.product_id
GROUP BY cc.category, cs.segments, p.category
HAVING  cc.category <> 'Churned' AND  cs.segments <> 'Low'
ORDER BY cc.category, cs.segments, p.category;


