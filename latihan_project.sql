-- SQL Retail Sales Analyst - p1
CREATE DATABASE sql_project_p2;

CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

SELECT * FROM retail_sales;

SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE customer_id IS NULL;

SELECT * FROM retail_sales
WHERE gender IS NULL;

SELECT transactions_id, sale_date
FROM retail_sales
WHERE age IS NULL
ORDER BY sale_date;

SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

SELECT *
FROM retail_sales
WHERE 
category ='Clothing' 
AND TO_CHAR(sale_Date, 'YYYY-MM')= '2022-11'
AND quantity >=4 ;

SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4

SELECT 
	category,
SUM(total_sale) as Total_sales,
COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY category 
ORDER BY total_orders ASC;

SELECT 
	ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category ='Beauty';

SELECT * FROM retail_sales
WHERE total_sale >= 1000

SELECT category,
		gender,
		COUNT(*) AS total_transaction
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY year, month
) as t1
WHERE rank = 1


SELECT
	customer_id,
	SUM(total_sale) AS Total_sales
FROM retail_Sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
