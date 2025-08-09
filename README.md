# Sales Marketing Performance Analysis - SQL + PowerBI

## Overview

This project analyzes sales and marketing performance from 2022 to 2024 using SQL and Power BI. It examines revenue, marketing campaigns, conversation rate, customer ratings and
others in order to uncover insights that can help businesses optimize strategies, improve targeting, and drive growth.

## Dataset
* Source: [Sales and Marketing Dataset](https://www.kaggle.com/datasets/mufnasnasimdeen/sales-and-marketing)
* Total Records: 1921
* Fields Include: SalesID, Customer Name, Product, Sales Date, Sales Amount, Sales Channel, Region, Marketing Campaign, etc

## Tools Used
* SQL: Used for data querying, data manipulation and exploration using MySQL Workbench
* Power BI: Data visualization and dashboard creation.
* CSV: How the original dataset was obtained from Kaggle.

## Database creation
### Step 1: Creating the database
```sql
CREATE DATABASE sales_marketing;
```
### Step 2: Importing Data from CSV into the sales table in the sales_marketing schema

### Step 3: Converted the Sales Date column to the correct DATE format, replaced the original column, and positioned it after the Product column.
``` sql
ALTER TABLE sales ADD COLUMN sales_date DATE;

UPDATE sales
SET sales_date = STR_TO_DATE(`Sales Date`, '%d/%m/%Y');

ALTER TABLE sales DROP COLUMN `Sales Date`;

ALTER TABLE sales MODIFY COLUMN sales_date DATE AFTER Product;
```
## Key Questions & Findings
### 1. What are the monthly sales trends over time?
```sql
SELECT DATE_FORMAT(sales_date, '%Y-%m') AS sales_month,
SUM(SalesAmount) AS total_revenue
FROM sales
GROUP BY
  sales_month
ORDER BY
 sales_month;
```
**Findings:** Sales fluctuated between 2022 and 2024, with notable peaks in April 2023 (63,653) and March 2024 (60,152), while the lowest month was August 2023 (41,320).
### 2. How do regions perform in terms of sales?
```sql
SELECT Region, SUM(SalesAmount) AS total_revenue
FROM sales
GROUP BY 1
ORDER BY 2 DESC;
```
**Findings:** Europe generated the highest sales (446,236), followed by Asia (423,293), North America (387,078), and South America (371,633).
### 3. What is the profit margin per product?
```sql
SELECT Product,
SUM(SalesAmount - CostPrice) AS profit
FROM sales
GROUP BY 1
ORDER BY 2 DESC;
```
**Findings:** Gaming Console Z achieved the highest profit (27,047), followed by Soundbar 360 (25,069) and Monitor HD 24 (24,468), with other products generating slightly lower profits.
### 4. Which sales reps have the highest total profit and highest conversion rates?
```sql
SELECT `Sales Rep`, SUM(SalesAmount) AS total_revenue,
ROUND(AVG(`Conversion Rate (%)`),2) AS conversion_rate
FROM sales
GROUP BY
 `Sales Rep`
ORDER BY
  total_revenue DESC, conversion_rate DESC;
```
**Findings:** Bob Martin leads in total revenue (227,572), followed by Monica Bell (224,992) and Sarah Wilson (212,625). Alice Johnson has the highest conversion rate (18.21%) despite lower total revenue.
### 5. What is the total revenue, cost, and profit per region and product category?
```sql
SELECT Region, Product, 
SUM(SalesAmount) AS total_sales, 
SUM(CostPrice) AS total_cost, 
SUM(SalesAmount - CostPrice) AS profit 
FROM sales
GROUP BY
  Region, Product
ORDER BY
  Region ASC, profit DESC;
```
**Findings:** In Asia, Soundbar 360 had the highest profit (8,418) on revenue 40,628 and cost 32,210. In Europe and North America, 
Gaming Console Z led profits (7,389 and 7,756) with revenues around 36,000+ and costs near 29,000-30,000. In South America, Wireless Speaker had top profit (6,368) with revenue 28,510 and cost 22,142.
### 6. Which marketing campaigns are driving the most revenue and highest conversion rates?
```sql
SELECT `Marketing Campaign`,
SUM(SalesAmount) AS total_revenue,
AVG(`Conversion Rate (%)`) AS conversion_rate
FROM sales
GROUP BY
  `Marketing Campaign`
ORDER BY
  total_revenue DESC, conversion_rate DESC;
```
**Findings:** Spring Promo 2024 generated the highest revenue (354,596), while New Year Campaign had the highest conversion rate (17.74%), followed closely by Fall Sales Campaign and Summer Deals 2024.

### 7. What is the average conversion rate by lead source and campaign?
```sql
SELECT `Lead Source`,
`Marketing Campaign`,
AVG(`Conversion Rate (%)`) AS avg_conversion_rate
FROM sales
GROUP BY
  `Lead Source`, `Marketing Campaign`
ORDER BY
  avg_conversion_rate DESC;
```
**Findings:** The highest average conversion rate is from Referral leads during the New Year Campaign (18.8%), followed by Social Media leads in the same campaign (18.57%) and Fall Sales Campaign (18.23%).
Conversion rates vary across lead sources and campaigns but generally stay between 16% and 18.8%.

### 8. What are the busiest sales days (by weekday)
```sql
SELECT DAYNAME(sales_date) AS week_days,
COUNT(*) AS sales_count
FROM sales
GROUP BY 1
ORDER BY 2 DESC;
```
**Findings:** Wednesday is the busiest sales day with 292 sales, followed by Friday (281) and Tuesday (279). Monday is the slowest day with 263 sales.

### 9. How does sales performance vary by channel across different regions and over time?
```sql
SELECT region,
`Sales Channel`,
DATE_FORMAT(sales_date, '%Y-%m') AS `month`,
SUM(SalesAmount) AS total_revenue
FROM sales
GROUP BY
  region, `Sales Channel`, `month`
ORDER BY
  region ASC,  `month` ASC; 
```
**Findings:** Online sales consistently generate more revenue than in-store across all regions and months. Regions with the strongest online sales include North America and Asia with revenue of 15,855 and 15,343 respectively.
In-store sales remain an important but smaller component in all regions.
### 10. What is the average customer rating by product and region?
```sql
SELECT Product, Region, AVG(`Customer Rating`) as ratings
FROM sales
GROUP BY Product, Region
ORDER BY Region; 
```
**Findings:** The highest average customer rating is for Camera Pro S in North America (6.48), followed by Smart TV QLED in North America (6.23) and Smartphone X in Asia (6.15). Ratings vary by product and region, generally ranging from around 3.9 to 6.5, with North America showing some of the highest ratings overall.
## Conclusion
This analysis proffers important insights into the sales and marketing performance of the business. It highlights the most impactful marketing campaigns, 
regions and products generating higher profits, and sales representatives with strong conversion rates and revenue contributions. 
Stakeholders can use this information to make data-driven decisions that optimize marketing efforts, improve sales strategies, allocate resources effectively, and ultimately drive sustainable business growth.
