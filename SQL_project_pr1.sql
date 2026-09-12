-- sql retail sales analysis 
Create Database sql_project_p1;

-- Using Database sales analysis
USE sql_project_p1;

-- create Table 
CREATE TABLE retail_sales
(
		  transactions_id int PRIMARY KEY,
		  sale_date DATE,
		  sale_time TIME,
		  customer_id INT,
		  gender VARCHAR(15),
		  age int DEFAULT NULL,
		  category  VARCHAR(15) ,
		  quantity int DEFAULT NULL,
		  price_per_unit FLOAT DEFAULT NULL,
		  cogs FLOAT,
		  Total_sales FLOAT
)

-- Select Table
SELECT * FROM sql_project_p1.retail_sales
LIMIT 10;
--
SELECT
	COUNT(*)
FROM sql_project_p1.retail_sales;

-- Checking for NULL
SELECT *
FROM sql_project_p1.retail_sales
WHERE transactions_id IS NULL
		OR  sale_date IS NULL
        OR  sale_time IS NULL
		OR  customer_id IS NULL
		OR  gender IS NULL
        OR  age IS NULL
        OR  category IS NULL
        OR  quantity IS NULL
        OR  price_per_unit IS NULL
        OR  cogs IS NULL
        OR  Total_sales IS NULL;

-- Deleting the null values 
DELETE FROM sql_project_p1.retail_sales   
   WHERE transactions_id IS NULL
		OR  sale_date IS NULL
        OR  sale_time IS NULL
		OR  customer_id IS NULL
		OR  gender IS NULL
        OR  age IS NULL
        OR  category IS NULL
        OR  quantity IS NULL
        OR  price_per_unit IS NULL
        OR  cogs IS NULL
        OR  Total_sales IS NULL;
        
-- DATA EXPLORRATION    
-- How much sales we have?
SELECT
		COUNT(*) AS Total_sales
FROM sql_project_p1.retail_sales;  

-- How many Unique customers we have?
SELECT
	COUNT(DISTINCT customer_id) AS Unique_customers
FROM sql_project_p1.retail_sales ;

-- How many Unique categories we have?
SELECT
	COUNT(DISTINCT category)
FROM sql_project_p1.retail_sales;

      
-- DATA ANALYSIS & BUSINESS KEY PROBLEMS 
-- Q1 - Write a SQL query to retrieve all columns for sales made on '2022-11-05:
-- Q2 - Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
-- Q3 - Write a SQL query to calculate the total sales (total_sale) for each category.:
-- Q4 - Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
-- Q5 - Write a SQL query to find all transactions where the total_sale is greater than 1000.:
-- Q6 - Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
-- Q7 - Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
-- Q8 - Write a SQL query to find the top 5 customers based on the highest total sales
-- Q9 - Write a SQL query to find the number of unique customers who purchased items from each category.:
-- Q10 - Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

-- Q1 - Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT *
FROM sql_project_p1.retail_sales
WHERE sale_date = '2022-11-05';

-- Q2 - Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT *
FROM sql_project_p1.retail_sales
WHERE category = 'Clothing' 
AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
AND quantity >= 4;

-- Q3 - Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT
		category,
		SUM(Total_sales) AS Net_sale
FROM sql_project_p1.retail_sales
GROUP BY Category;

-- Q4 - Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT 
		ROUND(avg(age), 2) as Average_age
FROM sql_project_p1.retail_sales
WHERE category = 'Beauty';

-- Q5 - Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM sql_project_p1.retail_sales
WHERE total_sales > 1000;

-- Q6 - Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
		gender,
        category,
		count(transactions_id) AS Total_transactions
FROM sql_project_p1.retail_sales
group by gender, category 
ORDER BY 1 ;

-- Q7 - Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT 
       Sales_Year,
       Sales_month,
	   Average_sales
From(    
SELECT
		Month(sale_date) AS Sales_month,
        Year(sale_date) AS Sales_Year,
		Round(avg(total_sales), 2) AS Average_sales,
        Rank() OVER(Partition by Month(sale_date)ORDER BY avg(total_sales)DESC) as Ranking
FROM sql_project_p1.retail_sales
GROUP BY 1, 2
)t
Where Ranking = 1;


-- Q8 - Write a SQL query to find the top 5 customers based on the highest total sales
SELECT 
		customer_id,
		sum(Total_sales) AS Net_Sales
FROM sql_project_p1.retail_sales
GROUP BY 1
ORDER BY 2 Desc 
LIMIT 5;

-- Q9 - Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT DISTINCT
		COUNT(DISTINCT Customer_id) AS cnt_unique_cs
FROM sql_project_p1.retail_sales
GROUP BY Category;

-- Q10 - Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
With hourly_sale AS
(
			SELECT 
					*,
					(Case when hour(sale_time) < 12 then 'Morning'
							when hour(sale_time) BETWEEN 12 AND 17 then 'Afternoon'
							when hour(sale_time) > 17 then 'Evening'
					END ) AS  shift
			FROM sql_project_p1.retail_sales
)
  SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;

-- END OF PROJECT --