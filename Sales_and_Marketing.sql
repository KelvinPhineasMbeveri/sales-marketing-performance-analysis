CREATE DATABASE sales_marketing;

USE sales_marketing;

-- Converted the Sales Date column to the correct DATE format, replaced the original column, and positioned it after the Product column.

ALTER TABLE sales ADD COLUMN sales_date DATE;

UPDATE sales
SET sales_date = STR_TO_DATE(`Sales Date`, '%d/%m/%Y');

ALTER TABLE sales DROP COLUMN `Sales Date`;

ALTER TABLE sales MODIFY COLUMN sales_date DATE AFTER Product;

-- 1. What are the monthly sales trends over time?

SELECT DATE_FORMAT(sales_date, '%Y-%m') AS sales_month,
SUM(SalesAmount) AS total_revenue
FROM sales
GROUP BY 
	sales_month
ORDER BY 
	sales_month;

-- 2. How do regions perform in terms of sales

SELECT Region, 
SUM(SalesAmount) AS total_revenue
FROM sales
GROUP BY 1
ORDER BY 2 DESC;

-- 3.What is the profit margin per product--

SELECT Product,
SUM(SalesAmount - CostPrice) AS profit
FROM sales
GROUP BY 1
ORDER BY 2 DESC;

-- 4. Which sales reps have the highest total profit and highest conversion rates?

SELECT `Sales Rep`, 
SUM(SalesAmount) AS total_revenue, 
ROUND(AVG(`Conversion Rate (%)`),2) AS conversion_rate
FROM sales
GROUP BY 
	`Sales Rep`
ORDER BY 
	total_revenue DESC, conversion_rate DESC;

-- 5. What is the total revenue, cost, and profit per region and product category?

SELECT Region, Product, 
SUM(SalesAmount) AS total_sales, 
SUM(CostPrice) AS total_cost, 
SUM(SalesAmount - CostPrice) AS profit 
FROM sales
GROUP BY  
	Region, Product
ORDER BY 
	Region ASC, profit DESC;

-- 6. Which marketing campaigns are driving the most revenue and highest conversion rates?

SELECT `Marketing Campaign`,
SUM(SalesAmount) AS total_revenue,
AVG(`Conversion Rate (%)`) AS conversion_rate
FROM sales
GROUP BY 
	`Marketing Campaign`
ORDER BY 
	total_revenue DESC, conversion_rate DESC;

-- 7. What is the average conversion rate by lead source and campaign?

SELECT `Lead Source`, 
`Marketing Campaign`, 
AVG(`Conversion Rate (%)`) AS avg_conversion_rate
FROM sales
GROUP BY 
	`Lead Source`, `Marketing Campaign`
ORDER BY 
	avg_conversion_rate DESC;

-- 8. what is the busiest sales day (by weekday)

SELECT DAYNAME(sales_date) AS week_days, 
COUNT(*) AS sales_count
FROM sales
GROUP BY 1
ORDER BY 2 DESC;

-- 9. How does sales performance vary by channel across different regions and over time?

SELECT region, 
`Sales Channel`, 
DATE_FORMAT(sales_date, '%Y-%m') AS `month`, 
SUM(SalesAmount) AS total_revenue
FROM sales
GROUP BY 
	region, `Sales Channel`, `month`
ORDER BY 
	region ASC,  `month` ASC; 

-- 10. What is the average customer rating by product and region?

SELECT Product, 
Region, 
AVG(`Customer Rating`) as ratings
FROM sales
GROUP BY 
Product, Region
ORDER BY 
	Region; 