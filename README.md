**Retail-sales Analysis**

📊 **E-Commerce Business Intelligence**: SQL & Python Analysis
📌 **Project Overview**
This project demonstrates a complete data pipeline and analytical workflow. I took raw e-commerce data, performed intensive data cleaning and transformation using Python (Pandas), and loaded the structured data into PostgreSQL.
The final phase involved writing complex SQL queries to solve five specific business use cases aimed at optimizing sales strategy and understanding regional performance.

**🛠️ The Data Pipeline**
Extraction: Loaded raw CSV data containing order details, shipping information, and financial metrics.
Transformation (Python):
Standardized column headers (lower_case_with_underscores).
Converted data types (specifically handling int64, float64, and datetime64[ns]).
Derived new business metrics for easier SQL ingestion.
Loading: Established a connection to PostgreSQL and pushed the cleaned dataframe into a structured table.
Analysis: Authored advanced SQL scripts using CTEs, Window Functions, and Aggregations.

**📈 Business Questions Answered**

**1. Top 10 Revenue-Generating Products**
Objective: Identify which products contribute the most to the company's bottom line.
SQL Technique: SUM(sale_price) aggregated by product_id with a LIMIT 10.

**2. Regional Sales Dominance (Top 5 per Region)**
Objective: Understand local market preferences by finding the most popular products in every specific region.
SQL Technique: Used DENSE_RANK() with PARTITION BY region to rank products within their respective territories.

**3. Month-over-Month (MoM) Comparison (2022 vs 2023)**
Objective: Visualize seasonal trends and identify if the company performed better month-by-month compared to the previous year.
SQL Technique: Created a pivoted view using CASE statements to align 2022 and 2023 sales side-by-side by month.

**4. Peak Performance Months by Category**
Objective: Determine the high-season for each product category (Furniture, Tech, etc.) to optimize inventory.
SQL Technique: Combined EXTRACT(MONTH...) with RANK() to find the single highest-selling month for every category.

**5. Sub-Category Profit Growth (2023 vs 2022)**
Objective: Identify the "Rising Stars" — sub-categories that showed the highest percentage growth in profit year-over-year.
SQL Technique: Utilized nested CTEs to calculate raw growth and NULLIF to handle percentage calculations safely.

**💻 Technical Snippet**: Profit Growth Calculation
sql
WITH cte AS (
    SELECT sub_category, EXTRACT(YEAR FROM order_date) AS order_year, SUM(profit) AS profit 
    FROM orders GROUP BY 1, 2
),
pivot_cte AS (
    SELECT sub_category,
    SUM(CASE WHEN order_year = 2022 THEN profit ELSE 0 END) AS p_2022,
    SUM(CASE WHEN order_year = 2023 THEN profit ELSE 0 END) AS p_2023
    FROM cte GROUP BY 1
)
SELECT *, (p_2023 - p_2022) * 100 / NULLIF(p_2022, 0) AS growth_pct
FROM pivot_cte
ORDER BY growth_pct DESC;
Use code with caution.

**🗝️ Key Insights**
Efficiency: By pivoting the data in SQL, we reduced the need for multiple reports, providing a single view of Year-over-Year performance.
Growth: Certain sub-categories showed over 100% profit growth, suggesting a shift in consumer demand.
Regionality: Top products vary significantly by region, indicating that a "one size fits all" marketing strategy may not be effective.
**
