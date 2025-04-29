
-- PostgreSQL SQL Script for Amazon Dataset Analysis

-- ============================================
-- DATABASE: Amazon Marketplace Analysis
-- DESCRIPTION: This SQL script analyzes orders, products, customers, sellers, and payments.
-- ============================================

-- ============================================
-- TABLES EXPLANATION:
-- category: Categories of products
-- customers: Customer details
-- inventory: Seller inventory information
-- order_items: Items included in each order
-- orders: Orders placed by customers
-- payments: Payments for orders
-- products: Products listed
-- sellers: Seller details
-- shipping: Shipping information for orders
-- ============================================

-- ============================================
-- 1. Question: List top 5 categories by total sales amount
-- ============================================
WITH category_sales AS (
    SELECT 
        p.category_id, 
        SUM(oi.price * oi.quantity) AS total_sales
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.category_id
)
SELECT 
    c.category_name, 
    cs.total_sales
FROM category_sales cs
JOIN category c ON cs.category_id = c.category_id
ORDER BY cs.total_sales DESC
LIMIT 5;

-- Explanation: We calculate total sales for each category and pick top 5.

-- ============================================
-- 2. Question: Find top 5 customers who spent the most
-- ============================================
SELECT 
    cu.customer_id, 
    cu.customer_fname || ' ' || cu.customer_lname AS customer_name,
    SUM(oi.price * oi.quantity) AS total_spent
FROM orders o
JOIN customers cu ON o.customer_id = cu.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY cu.customer_id, cu.customer_fname, cu.customer_lname
ORDER BY total_spent DESC
LIMIT 5;

-- Explanation: Joining orders and order_items to sum spending by customer.

-- ============================================
-- 3. Question: What are the top 5 best-selling products?
-- ============================================
SELECT 
    p.product_name, 
    SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- Explanation: Sum quantity sold for each product.

-- ============================================
-- 4. Question: Monthly revenue trend
-- ============================================
SELECT 
    DATE_TRUNC('month', o.order_purchase_date) AS month,
    SUM(oi.price * oi.quantity) AS monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- Explanation: Aggregating revenue month by month.

-- ============================================
-- 5. Question: Average delivery time (in days) per seller
-- ============================================
SELECT 
    s.seller_id, 
    s.seller_name, 
    AVG(sh.shipping_delivery_date - sh.shipping_estimated_delivery_date) AS avg_delivery_days
FROM shipping sh
JOIN sellers s ON sh.seller_id = s.seller_id
GROUP BY s.seller_id, s.seller_name
ORDER BY avg_delivery_days;

-- Explanation: Difference between estimated and actual delivery dates.

-- ============================================
-- 6. Question: Top 5 sellers with most products listed
-- ============================================
SELECT 
    i.seller_id, 
    s.seller_name, 
    COUNT(DISTINCT i.product_id) AS total_products
FROM inventory i
JOIN sellers s ON i.seller_id = s.seller_id
GROUP BY i.seller_id, s.seller_name
ORDER BY total_products DESC
LIMIT 5;

-- Explanation: Number of unique products each seller lists.

-- ============================================
-- 7. Question: Repeat customers (more than 1 order)
-- ============================================
SELECT 
    c.customer_id, 
    c.customer_fname || ' ' || c.customer_lname AS customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, customer_name
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;

-- Explanation: Customers with more than 1 order.

-- ============================================
-- 8. Question: Find products with no sales
-- ============================================
SELECT 
    p.product_id, 
    p.product_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;

-- Explanation: Products that never appeared in any order_items.

-- ============================================
-- 9. Question: Orders with multiple sellers involved
-- ============================================
SELECT 
    o.order_id, 
    COUNT(DISTINCT i.seller_id) AS distinct_sellers
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN inventory i ON oi.inventory_id = i.inventory_id
GROUP BY o.order_id
HAVING COUNT(DISTINCT i.seller_id) > 1;

-- Explanation: Orders where items came from multiple sellers.

-- ============================================
-- 10. Question: Payment methods usage distribution
-- ============================================
SELECT 
    payment_type, 
    COUNT(payment_id) AS count_of_payments
FROM payments
GROUP BY payment_type
ORDER BY count_of_payments DESC;

-- Explanation: Count usage of each payment method.

-- ============================================
-- 11. Question: Find the customers with delayed shipments
-- ============================================
SELECT DISTINCT
    c.customer_id, 
    c.customer_fname || ' ' || c.customer_lname AS customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN shipping s ON o.order_id = s.order_id
WHERE s.shipping_delivery_date > s.shipping_estimated_delivery_date;

-- Explanation: Customers who received shipments late.

-- ============================================
-- 12. Question: List of most common products ordered per city
-- ============================================
WITH product_city AS (
    SELECT 
        cu.customer_city, 
        p.product_name, 
        COUNT(oi.order_item_id) AS order_count
    FROM customers cu
    JOIN orders o ON cu.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY cu.customer_city, p.product_name
)
SELECT DISTINCT ON (customer_city)
    customer_city, 
    product_name, 
    order_count
FROM product_city
ORDER BY customer_city, order_count DESC;

-- Explanation: Most frequently ordered product per city.

-- ============================================
-- 13. Question: Highest single order value (order_id + value)
-- ============================================
SELECT 
    o.order_id, 
    SUM(oi.price * oi.quantity) AS total_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id
ORDER BY total_order_value DESC
LIMIT 1;

-- Explanation: Order with maximum total value.

-- ============================================
-- 14. Question: Revenue contribution by each seller
-- ============================================
SELECT 
    s.seller_id, 
    s.seller_name, 
    SUM(oi.price * oi.quantity) AS seller_revenue
FROM sellers s
JOIN inventory i ON s.seller_id = i.seller_id
JOIN order_items oi ON i.inventory_id = oi.inventory_id
GROUP BY s.seller_id, s.seller_name
ORDER BY seller_revenue DESC;

-- Explanation: How much revenue each seller contributed.

-- ============================================
-- 15. Question: Year-over-Year growth in total sales
-- ============================================
WITH yearly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM o.order_purchase_date) AS sales_year,
        SUM(oi.price * oi.quantity) AS total_sales
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY sales_year
)
SELECT 
    sales_year, 
    total_sales,
    LAG(total_sales) OVER (ORDER BY sales_year) AS previous_year_sales,
    ROUND((total_sales - LAG(total_sales) OVER (ORDER BY sales_year)) / LAG(total_sales) OVER (ORDER BY sales_year) * 100, 2) AS growth_percentage
FROM yearly_sales
ORDER BY sales_year;

-- Explanation: Calculate year-over-year percentage growth using window function.
