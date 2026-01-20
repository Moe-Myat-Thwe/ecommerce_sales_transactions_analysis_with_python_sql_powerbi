/**********************E-commerce Sales Performance & Profitability Analysis ****************************************/ 

/* This project focuses on analyzing e-commerce sales transaction data 
   to uncover insights related to revenue performance, profitability, discount impact, customer behavior, and operational efficiency.*/
   
-- Date range
SELECT MIN(order_date) AS first_order,
       MAX(order_date) AS last_order
FROM ecommerce_transactions;

-- Total Order
SELECT  COUNT(DISTINCT order_id) AS num_distinct_orders , COUNT(*) AS total_order  FROM ecommerce_transactions;
-- Since num_distinct_orders equals total_order, each row represents exactly one order,

-- ******************************************************************************************************************
/*Sales & Revenue Performance*/
-- ******************************************************************************************************************

-- Total Revenue, Total Profit, Total Orders, Average Order Value(AOV)
SELECT
    ROUND(SUM(total_amount), 2) AS total_revenue,
	ROUND(SUM(profit), 2) AS total_profit,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(total_amount) / COUNT(order_id), 2) AS avg_order_value
FROM ecommerce_transactions;

-- Monthly Revenue and Profit trend
SELECT DATE_FORMAT(order_date, '%Y-%m'),
	   ROUND(SUM(total_amount), 2) AS monthly_revenue,
       	ROUND(SUM(profit), 2) AS monthly_profit
FROM ecommerce_transactions
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY DATE_FORMAT(order_date, '%Y-%m') DESC;

-- ******************************************************************************************************************
/*Category Performance*/
-- ******************************************************************************************************************

-- Revenue & Profit by Category
SELECT category, 
	   COUNT(order_id) AS orders,
	   ROUND(SUM(total_amount), 2) AS total_revenue,
	   ROUND(SUM(profit), 2) AS total_profit
FROM ecommerce_transactions
GROUP BY category
ORDER BY total_revenue DESC;  

-- Profit Margin %
SELECT
    category,
    ROUND(SUM(profit) / SUM(total_amount) * 100, 2) AS profit_margin_pctှ
    -- which is the correct way
FROM ecommerce_transactions
GROUP BY category
ORDER BY profit_margin_pct DESC;

-- ******************************************************************************************************************
/*Discount Impact Analysis*/
-- ******************************************************************************************************************
SELECT
    CASE 
        WHEN discount = 0 THEN 'No discount'
        WHEN discount > 0 and discount <= 0.1 THEN 'Low discount'
        WHEN discount > 0.1 and discount <= 0.2 THEN 'Medium discount'
		WHEN discount > 0.2 and discount <= 0.3 THEN 'High discount'
        ELSE 'Heavy discount'
    END AS discount_type,
    COUNT(order_id) AS orders,
    ROUND(AVG(total_amount), 2) AS avg_order_value,
	ROUND(SUM(total_amount), 2) AS revenue,
	ROUND(SUM(profit) / SUM(total_amount) * 100, 2) AS profit_margin_pct,
    ROUND(SUM(profit), 2) AS total_profit
FROM ecommerce_transactions
GROUP BY discount_type
ORDER BY total_profit DESC;

-- ******************************************************************************************************************
/*Customer Demographics*/
-- ******************************************************************************************************************

-- Revenue by Age Group
SELECT
    CASE
        WHEN customer_age < 25 THEN 'Under 25'
        WHEN customer_age BETWEEN 25 AND 34 THEN '25-34'
        WHEN customer_age BETWEEN 35 AND 44 THEN '35-44'
        WHEN customer_age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    COUNT(order_id) AS orders,
    ROUND(SUM(total_amount), 2) AS revenue
FROM ecommerce_transactions
GROUP BY age_group
ORDER BY revenue DESC;

-- Revenue by Gender
SELECT
    customer_gender,
    COUNT(order_id) AS orders,
    ROUND(SUM(total_amount)) AS revenue
FROM ecommerce_transactions
GROUP BY customer_gender;

-- ******************************************************************************************************************
/*Payment Method Analysis*/
-- ******************************************************************************************************************

SELECT
    payment_method,
    COUNT(order_id) AS orders,
    ROUND(AVG(total_amount), 2) AS avg_order_value,
	ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM ecommerce_transactions
GROUP BY payment_method
ORDER BY avg_order_value DESC;

-- ******************************************************************************************************************
/*Region Performance*/
-- ******************************************************************************************************************

SELECT
    region,
    COUNT(order_id) AS orders,
    ROUND(SUM(total_amount), 2) AS revenue,
	ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(delivery_time_days), 1) AS avg_delivery_days,
	ROUND(AVG(shipping_cost), 2) AS avg_shipping_cost
FROM ecommerce_transactions
GROUP BY region
ORDER BY revenue DESC;

-- ******************************************************************************************************************
/*Logistics & Delivery Impact*/
-- ******************************************************************************************************************

-- Delivery Time vs Returns
SELECT
    CASE
        WHEN delivery_time_days <= 3 THEN '0-3 days'
        WHEN delivery_time_days <= 5 THEN '4-5 days'
        ELSE '6+ days'
    END AS delivery_bucket,
    COUNT(order_id) AS total_orders,
    SUM(CASE WHEN returned = 'yes' THEN 1 ELSE 0 END) AS returned_orders,
    ROUND(
        SUM(CASE WHEN returned = 'yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(order_id),
        2
    ) AS return_rate_pct
FROM ecommerce_transactions
GROUP BY delivery_bucket;

-- ******************************************************************************************************************
/*Return Analysis*/
-- ******************************************************************************************************************

SELECT
    category,
    COUNT(order_id) AS total_orders,
    SUM(CASE WHEN returned = 'Yes' THEN 1 ELSE 0 END) AS returned_orders,
    ROUND(
        SUM(CASE WHEN returned = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(order_id),
        2
    ) AS return_rate_pct
FROM ecommerce_transactions
GROUP BY category
ORDER BY return_rate_pct DESC;

-- ******************************************************************************************************************
/*Top Customers*/
-- ******************************************************************************************************************

SELECT
    customer_id,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(total_amount), 2) AS revenue
FROM ecommerce_transactions
GROUP BY customer_id
ORDER BY revenue DESC
LIMIT 10;

-- ******************************************************************************************************************
/*High Revenue but Low Profit Orders*/
-- ******************************************************************************************************************

SELECT
    order_id,
    category,
    total_amount,
    profit_margin,
    shipping_cost
FROM ecommerce_transactions
WHERE profit_margin < 0
ORDER BY total_amount DESC;

-- ******************************************************************************************************************
/*Business Summary Query */
-- ******************************************************************************************************************

SELECT
    category,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
	ROUND((SUM(profit) / SUM(total_amount))*100, 2) AS profit_margin_pct,
    ROUND(AVG(delivery_time_days)) AS avg_delivery_days
FROM ecommerce_transactions
GROUP BY category
ORDER BY total_profit DESC;









