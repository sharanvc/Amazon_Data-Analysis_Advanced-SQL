# Amazon_Data-Analysis_Advanced-SQL

## Project Overview
This project demonstrates advanced SQL analytics on a simulated Amazon marketplace dataset. Using PostgreSQL, we explore customer behavior, seller performance, product sales, shipping efficiency, and overall business trends through 15 complex SQL queries.

The goal is to showcase expertise in database querying, business insights extraction, and working with relational data models.

## Dataset Description
The dataset consists of the following tables:
- **category**: Categories under which products are listed.
- **customers**: Customer demographic and location information.
- **inventory**: Product inventory managed by sellers.
- **order_items**: Items included in each order, including price and quantity.
- **orders**: Details of orders placed by customers.
- **payments**: Payment information related to orders.
- **products**: Products listed for sale.
- **sellers**: Information about sellers.
- **shipping**: Shipping details including delivery times and dates.

## Key Features
- **Advanced SQL Queries**: Using joins, window functions, aggregations, subqueries, CTEs, date functions.
- **Business Insights**: Customer analysis, product performance, seller contributions, and shipping analysis.
- **PostgreSQL Syntax**: Built specifically for PostgreSQL environments, using features like `ILIKE`, `EXTRACT`, and window functions (`LAG`).

## Queries Solved
1. Top 5 Categories by Total Sales
2. Top 5 Customers by Total Spending
3. Top 5 Best-Selling Products
4. Monthly Revenue Trend
5. Average Delivery Time per Seller
6. Top 5 Sellers with Most Products Listed
7. Repeat Customers Analysis
8. Products with No Sales
9. Orders Involving Multiple Sellers
10. Payment Methods Usage Analysis
11. Customers Who Received Late Shipments
12. Most Commonly Ordered Products per City
13. Highest Single Order Value
14. Revenue Contribution by Each Seller
15. Year-over-Year Growth in Total Sales

Each query is clearly documented with questions and detailed explanations in the `.sql` file.

## How to Run
1. Install PostgreSQL if not already installed.
2. Create a database and load the provided dataset using the `Schema_amazon_data.sql` file.
3. Load the CSV files into their respective tables.
4. Execute the `amazon_data_analysis_project.sql` script.

## Project Structure
```
├── category.csv
├── customers.csv
├── inventory.csv
├── order_items.csv
├── orders.csv
├── payments.csv
├── products.csv
├── sellers.csv
├── shipping.csv
├── Schema_amazon_data.sql
├── amazon_data_analysis_project.sql   <-- (Advanced SQL queries)
├── README.md
```

## Requirements
- PostgreSQL 13+
- Basic understanding of SQL
- Optional: pgAdmin for easier database management

## Author
- **Name**: Sharan Vivek
- 
## License
This project is for educational purposes. Feel free to use it, modify it, or extend it for your learning or portfolio!

