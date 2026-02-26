Drop Table orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,               -- int64 mapped to INT
    order_date TIMESTAMP,
    ship_mode VARCHAR(20),                  -- object mapped to VARCHAR(20)
    segment VARCHAR(20),
    country VARCHAR(20),
    city VARCHAR(20),
    state VARCHAR(20),
    postal_code INT,                        -- int64 mapped to INT
    region VARCHAR(20),
    category VARCHAR(20),
    sub_category VARCHAR(20),
    product_id VARCHAR(20),
    quantity INT,                           -- int64 mapped to INT
    discount FLOAT,
    sale_price FLOAT,
    profit FLOAT
);

SELECT * FROM orders;

-- Find the Top 10 Revenue Generating Products 

Select product_id, Sum(sale_price) as Total_sales FROM orders
Group by product_id order by Total_sales desc limit 10 ;

--Top 5 selling products in Each Region 
with rg_sale as(
select region,product_id,sum(sale_price) as total_sales
from orders
group by region , product_id)
select * from(
select * , row_number()over(partition by region order by total_sales desc) as rn from rg_sale) A
where rn <=5

--Find month over month growth comparision for 2020 and 2023 sales 
WITH cte AS (
    SELECT  
        EXTRACT(YEAR FROM order_date) AS order_year, 
        EXTRACT(MONTH FROM order_date) AS order_month,
        SUM(sale_price) AS sales 
    FROM orders
    GROUP BY order_year,order_month
)
SELECT 
    order_month,
    SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM cte
GROUP BY order_month
ORDER BY order_month;



--For each category which month had the highest sales
WITH category_monthly_sales AS (
    SELECT 
        category,
        EXTRACT(YEAR FROM order_date) AS order_year,
        EXTRACT(MONTH FROM order_date) AS order_month,
        SUM(sale_price) AS total_sales
    FROM orders
    GROUP BY category, order_year, order_month
),
ranked_sales AS (
    SELECT 
        category,
        order_year,
        order_month,
        total_sales,
        RANK() OVER(PARTITION BY category ORDER BY total_sales DESC) as sales_rank
    FROM category_monthly_sales
)
SELECT 
    category,
    order_year,
    order_month,
    total_sales
FROM ranked_sales
WHERE sales_rank = 1;

-- which subcategory has highest growth by profit in compare with 2023 and 2022
with cte as(
select sub_category ,
extract( year from order_date) as  order_year,
sum(profit) as profit from orders
group by sub_category,extract( year from order_date)
), cte2 as(
select  sub_category,
sum(case when order_year=2022 then profit else 0 end) as profit_2022,
sum(case when order_year=2023 then profit else 0 end )as profit_2023
from cte 
group by sub_category 
order by  sub_category )
select * , (profit_2023-profit_2022)*100/profit_2022 as GROWTH 
from cte2;
