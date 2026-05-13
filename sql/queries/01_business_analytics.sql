-- ============================================
-- ADVANCED SQL QUERIES FOR BUSINESS ANALYTICS
-- ============================================
-- This file contains comprehensive SQL queries for e-commerce analytics

-- ============================================
-- 1. TOP CUSTOMERS ANALYSIS
-- ============================================

-- Query 1.1: Top 10 Customers by Total Revenue
-- Uses: JOIN, GROUP BY, ORDER BY, LIMIT
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    c.address_city,
    c.address_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_revenue,
    AVG(o.total_amount) AS avg_order_value,
    MIN(o.order_date) AS first_purchase,
    MAX(o.order_date) AS last_purchase,
    DATEDIFF(MAX(o.order_date), MIN(o.order_date)) AS days_as_customer
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.address_city, c.address_state
ORDER BY total_revenue DESC
LIMIT 10;

-- Query 1.2: Top Customers by Order Frequency
-- Uses: COUNT, GROUP BY, HAVING
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    c.customer_segment,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.customer_segment
HAVING COUNT(DISTINCT o.order_id) >= 3
ORDER BY order_count DESC, total_spent DESC;

-- Query 1.3: Customer Lifetime Value (CLV) Analysis
-- Uses: Window Functions, CTE
WITH customer_stats AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.email,
        c.customer_segment,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(o.total_amount) AS total_revenue,
        AVG(o.total_amount) AS avg_order_value,
        MIN(o.order_date) AS first_order_date,
        MAX(o.order_date) AS last_order_date,
        DATEDIFF(CURDATE(), MIN(o.order_date)) AS days_since_first_order
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.status IN ('Delivered', 'Shipped')
    GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.customer_segment
),
clv_calculation AS (
    SELECT
        *,
        total_revenue / NULLIF(days_since_first_order, 0) * 365 AS annual_revenue_rate,
        total_revenue * 1.2 AS projected_clv_20pct_growth
    FROM customer_stats
)
SELECT
    customer_id,
    customer_name,
    email,
    customer_segment,
    total_orders,
    total_revenue,
    avg_order_value,
    annual_revenue_rate,
    projected_clv_20pct_growth,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
    RANK() OVER (ORDER BY total_orders DESC) AS frequency_rank
FROM clv_calculation
ORDER BY total_revenue DESC;

-- ============================================
-- 2. BEST-SELLING PRODUCTS ANALYSIS
-- ============================================

-- Query 2.1: Top 10 Best-Selling Products by Revenue
-- Uses: JOIN, GROUP BY, ORDER BY
SELECT
    p.product_id,
    p.product_name,
    p.sku,
    c.category_name,
    p.price,
    COUNT(DISTINCT oi.order_id) AS order_count,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.total_price) AS total_revenue,
    AVG(oi.unit_price) AS avg_selling_price,
    p.rating_avg,
    p.review_count
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY p.product_id, p.product_name, p.sku, c.category_name, p.price, p.rating_avg, p.review_count
ORDER BY total_revenue DESC
LIMIT 10;

-- Query 2.2: Top Products by Quantity Sold
-- Uses: SUM, GROUP BY
SELECT
    p.product_id,
    p.product_name,
    p.sku,
    c.category_name,
    p.price,
    SUM(oi.quantity) AS total_quantity_sold,
    COUNT(DISTINCT oi.order_id) AS unique_orders,
    SUM(oi.total_price) AS total_revenue,
    p.stock_quantity,
    p.rating_avg
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY p.product_id, p.product_name, p.sku, c.category_name, p.price, p.stock_quantity, p.rating_avg
ORDER BY total_quantity_sold DESC
LIMIT 10;

-- Query 2.3: Product Performance by Category
-- Uses: GROUP BY, ROLLUP
SELECT
    COALESCE(c.category_name, 'ALL CATEGORIES') AS category_name,
    COUNT(DISTINCT p.product_id) AS total_products,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.total_price) AS total_revenue,
    AVG(p.rating_avg) AS avg_category_rating,
    ROUND(SUM(oi.total_price) / NULLIF(SUM(oi.quantity), 0), 2) AS avg_price_per_unit
FROM products p
JOIN categories c ON p.category_id = c.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id AND o.status IN ('Delivered', 'Shipped')
GROUP BY c.category_name WITH ROLLUP
ORDER BY category_name;

-- Query 2.4: Low Stock Alert for Popular Products
-- Uses: HAVING, Subquery
SELECT
    p.product_id,
    p.product_name,
    p.sku,
    c.category_name,
    p.stock_quantity,
    p.reorder_level,
    sales_stats.total_quantity_sold,
    sales_stats.avg_monthly_sales,
    sales_stats.months_of_stock_remaining
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN (
    SELECT
        oi.product_id,
        SUM(oi.quantity) AS total_quantity_sold,
        ROUND(SUM(oi.quantity) / 12.0, 2) AS avg_monthly_sales,
        ROUND(p.stock_quantity / NULLIF(SUM(oi.quantity) / 12.0, 0), 2) AS months_of_stock_remaining
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.status IN ('Delivered', 'Shipped')
      AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
    GROUP BY oi.product_id, p.stock_quantity
) sales_stats ON p.product_id = sales_stats.product_id
WHERE p.stock_quantity <= p.reorder_level
   OR sales_stats.months_of_stock_remaining < 2
ORDER BY sales_stats.months_of_stock_remaining ASC;

-- ============================================
-- 3. MONTHLY REVENUE TRENDS
-- ============================================

-- Query 3.1: Monthly Revenue Analysis
-- Uses: DATE functions, GROUP BY
SELECT
    YEAR(o.order_date) AS year,
    MONTH(o.order_date) AS month,
    DATE_FORMAT(o.order_date, '%Y-%m') AS year_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(o.total_amount) AS total_revenue,
    AVG(o.total_amount) AS avg_order_value,
    SUM(o.subtotal) AS gross_revenue,
    SUM(o.tax_amount) AS total_tax,
    SUM(o.shipping_amount) AS total_shipping,
    SUM(o.discount_amount) AS total_discounts
FROM orders o
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY YEAR(o.order_date), MONTH(o.order_date), DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY year DESC, month DESC;

-- Query 3.2: Revenue Trend with Previous Month Comparison
-- Uses: Window Functions (LAG)
WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS year_month,
        SUM(o.total_amount) AS total_revenue,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT o.customer_id) AS unique_customers
    FROM orders o
    WHERE o.status IN ('Delivered', 'Shipped')
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT
    year_month,
    total_revenue,
    total_orders,
    unique_customers,
    LAG(total_revenue) OVER (ORDER BY year_month) AS prev_month_revenue,
    LAG(total_orders) OVER (ORDER BY year_month) AS prev_month_orders,
    ROUND((total_revenue - LAG(total_revenue) OVER (ORDER BY year_month)) /
          NULLIF(LAG(total_revenue) OVER (ORDER BY year_month), 0) * 100, 2) AS revenue_growth_pct,
    ROUND((total_orders - LAG(total_orders) OVER (ORDER BY year_month)) /
          NULLIF(LAG(total_orders) OVER (ORDER BY year_month), 0) * 100, 2) AS orders_growth_pct
FROM monthly_revenue
ORDER BY year_month DESC;

-- Query 3.3: Quarterly Revenue Analysis
-- Uses: QUARTER function, GROUP BY
SELECT
    YEAR(o.order_date) AS year,
    QUARTER(o.order_date) AS quarter,
    CONCAT(YEAR(o.order_date), '-Q', QUARTER(o.order_date)) AS year_quarter,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(o.total_amount) AS total_revenue,
    AVG(o.total_amount) AS avg_order_value,
    SUM(o.discount_amount) AS total_discounts
FROM orders o
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY YEAR(o.order_date), QUARTER(o.order_date)
ORDER BY year DESC, quarter DESC;

-- Query 3.4: Daily Revenue Trend (Last 30 Days)
-- Uses: DATE_SUB, GROUP BY
SELECT
    DATE(o.order_date) AS order_date,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(o.total_amount) AS total_revenue,
    AVG(o.total_amount) AS avg_order_value
FROM orders o
WHERE o.status IN ('Delivered', 'Shipped')
  AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY DATE(o.order_date)
ORDER BY order_date DESC;

-- ============================================
-- 4. CUSTOMER RETENTION ANALYSIS
-- ============================================

-- Query 4.1: Customer Retention Rate by Month
-- Uses: CTE, Window Functions
WITH customer_cohorts AS (
    SELECT
        customer_id,
        DATE_FORMAT(MIN(order_date), '%Y-%m') AS cohort_month
    FROM orders
    WHERE status IN ('Delivered', 'Shipped')
    GROUP BY customer_id
),
monthly_activity AS (
    SELECT
        cc.customer_id,
        cc.cohort_month,
        DATE_FORMAT(o.order_date, '%Y-%m') AS activity_month,
        DATEDIFF(o.order_date, STR_TO_DATE(CONCAT(cc.cohort_month, '-01'), '%Y-%m-%d')) AS days_since_cohort
    FROM customer_cohorts cc
    JOIN orders o ON cc.customer_id = o.customer_id
    WHERE o.status IN ('Delivered', 'Shipped')
    GROUP BY cc.customer_id, cc.cohort_month, DATE_FORMAT(o.order_date, '%Y-%m')
),
retention_calculation AS (
    SELECT
        cohort_month,
        activity_month,
        COUNT(DISTINCT customer_id) AS active_customers,
        FIRST_VALUE(COUNT(DISTINCT customer_id)) OVER (PARTITION BY cohort_month ORDER BY activity_month) AS cohort_size
    FROM monthly_activity
    GROUP BY cohort_month, activity_month
)
SELECT
    cohort_month,
    activity_month,
    cohort_size,
    active_customers,
    ROUND(active_customers * 100.0 / NULLIF(cohort_size, 0), 2) AS retention_rate_pct,
    PERIOD_DIFF(PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM STR_TO_DATE(CONCAT(activity_month, '-01'), '%Y-%m-%d')),
                           EXTRACT(YEAR_MONTH FROM STR_TO_DATE(CONCAT(cohort_month, '-01'), '%Y-%m-%d'))) AS month_number
FROM retention_calculation
ORDER BY cohort_month DESC, month_number;

-- Query 4.2: Repeat Purchase Analysis
-- Uses: Subquery, HAVING
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    c.customer_segment,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    MIN(o.order_date) AS first_purchase,
    MAX(o.order_date) AS last_purchase,
    DATEDIFF(MAX(o.order_date), MIN(o.order_date)) AS days_between_first_and_last,
    ROUND(DATEDIFF(MAX(o.order_date), MIN(o.order_date)) / NULLIF(COUNT(DISTINCT o.order_id) - 1, 0), 0) AS avg_days_between_orders,
    CASE
        WHEN COUNT(DISTINCT o.order_id) = 1 THEN 'One-time'
        WHEN COUNT(DISTINCT o.order_id) BETWEEN 2 AND 4 THEN 'Occasional'
        WHEN COUNT(DISTINCT o.order_id) BETWEEN 5 AND 9 THEN 'Regular'
        ELSE 'Loyal'
    END AS purchase_frequency_segment
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.customer_segment
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY total_orders DESC, total_spent DESC;

-- Query 4.3: Churn Risk Analysis
-- Uses: DATEDIFF, CASE
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    c.customer_segment,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    MAX(o.order_date) AS last_purchase_date,
    DATEDIFF(CURDATE(), MAX(o.order_date)) AS days_since_last_purchase,
    CASE
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) <= 30 THEN 'Active'
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) BETWEEN 31 AND 90 THEN 'At Risk'
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) BETWEEN 91 AND 180 THEN 'High Risk'
        ELSE 'Churned'
    END AS churn_status,
    CASE
        WHEN COUNT(DISTINCT o.order_id) = 1 THEN 'One-time Buyer'
        WHEN COUNT(DISTINCT o.order_id) BETWEEN 2 AND 4 THEN 'Occasional Buyer'
        WHEN COUNT(DISTINCT o.order_id) BETWEEN 5 AND 9 THEN 'Regular Buyer'
        ELSE 'Loyal Buyer'
    END AS buyer_type
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.customer_segment
ORDER BY days_since_last_purchase DESC, total_spent DESC;

-- ============================================
-- 5. AVERAGE ORDER VALUE ANALYSIS
-- ============================================

-- Query 5.1: Average Order Value by Customer Segment
-- Uses: GROUP BY, CASE
SELECT
    c.customer_segment,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(o.total_amount) AS total_revenue,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value,
    ROUND(SUM(o.total_amount) / COUNT(DISTINCT o.customer_id), 2) AS revenue_per_customer,
    MIN(o.total_amount) AS min_order_value,
    MAX(o.total_amount) AS max_order_value,
    ROUND(STDDEV(o.total_amount), 2) AS std_dev_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY c.customer_segment
ORDER BY avg_order_value DESC;

-- Query 5.2: Average Order Value by Payment Method
-- Uses: GROUP BY
SELECT
    o.payment_method,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(o.total_amount) AS total_revenue,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value,
    ROUND(SUM(o.total_amount) * 100.0 / NULLIF(SUM(o.total_amount) OVER (), 0), 2) AS revenue_share_pct,
    COUNT(CASE WHEN o.payment_status = 'Completed' THEN 1 END) AS successful_payments,
    COUNT(CASE WHEN o.payment_status = 'Failed' THEN 1 END) AS failed_payments
FROM orders o
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY o.payment_method
ORDER BY total_revenue DESC;

-- Query 5.3: Order Value Distribution
-- Uses: CASE, GROUP BY
SELECT
    CASE
        WHEN o.total_amount < 50 THEN 'Under $50'
        WHEN o.total_amount BETWEEN 50 AND 99.99 THEN '$50 - $99'
        WHEN o.total_amount BETWEEN 100 AND 199.99 THEN '$100 - $199'
        WHEN o.total_amount BETWEEN 200 AND 499.99 THEN '$200 - $499'
        WHEN o.total_amount BETWEEN 500 AND 999.99 THEN '$500 - $999'
        WHEN o.total_amount BETWEEN 1000 AND 1999.99 THEN '$1,000 - $1,999'
        ELSE '$2,000+'
    END AS order_value_bucket,
    COUNT(DISTINCT o.order_id) AS order_count,
    ROUND(COUNT(DISTINCT o.order_id) * 100.0 / NULLIF(COUNT(DISTINCT o.order_id) OVER (), 0), 2) AS order_percentage,
    SUM(o.total_amount) AS total_revenue,
    ROUND(SUM(o.total_amount) * 100.0 / NULLIF(SUM(o.total_amount) OVER (), 0), 2) AS revenue_percentage,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value
FROM orders o
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY
    CASE
        WHEN o.total_amount < 50 THEN 'Under $50'
        WHEN o.total_amount BETWEEN 50 AND 99.99 THEN '$50 - $99'
        WHEN o.total_amount BETWEEN 100 AND 199.99 THEN '$100 - $199'
        WHEN o.total_amount BETWEEN 200 AND 499.99 THEN '$200 - $499'
        WHEN o.total_amount BETWEEN 500 AND 999.99 THEN '$500 - $999'
        WHEN o.total_amount BETWEEN 1000 AND 1999.99 THEN '$1,000 - $1,999'
        ELSE '$2,000+'
    END
ORDER BY
    CASE
        WHEN o.total_amount < 50 THEN 1
        WHEN o.total_amount BETWEEN 50 AND 99.99 THEN 2
        WHEN o.total_amount BETWEEN 100 AND 199.99 THEN 3
        WHEN o.total_amount BETWEEN 200 AND 499.99 THEN 4
        WHEN o.total_amount BETWEEN 500 AND 999.99 THEN 5
        WHEN o.total_amount BETWEEN 1000 AND 1999.99 THEN 6
        ELSE 7
    END;

-- ============================================
-- 6. REGION-WISE SALES ANALYSIS
-- ============================================

-- Query 6.1: Sales by State
-- Uses: GROUP BY, ORDER BY
SELECT
    c.address_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(o.total_amount) AS total_revenue,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value,
    ROUND(SUM(o.total_amount) * 100.0 / NULLIF(SUM(o.total_amount) OVER (), 0), 2) AS revenue_share_pct,
    MIN(o.order_date) AS first_order,
    MAX(o.order_date) AS last_order
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY c.address_state
ORDER BY total_revenue DESC;

-- Query 6.2: Sales by City (Top 20)
-- Uses: GROUP BY, LIMIT
SELECT
    c.address_city,
    c.address_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(o.total_amount) AS total_revenue,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value,
    ROUND(SUM(o.total_amount) * 100.0 / NULLIF(SUM(o.total_amount) OVER (), 0), 2) AS revenue_share_pct
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY c.address_city, c.address_state
ORDER BY total_revenue DESC
LIMIT 20;

-- Query 6.3: Regional Product Preferences
-- Uses: GROUP BY, RANK
WITH regional_sales AS (
    SELECT
        c.address_state,
        p.product_id,
        p.product_name,
        c.category_name,
        SUM(oi.quantity) AS total_quantity_sold,
        SUM(oi.total_price) AS total_revenue,
        COUNT(DISTINCT oi.order_id) AS order_count
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN categories cat ON p.category_id = cat.category_id
    WHERE o.status IN ('Delivered', 'Shipped')
    GROUP BY c.address_state, p.product_id, p.product_name, c.category_name
)
SELECT
    address_state,
    product_id,
    product_name,
    category_name,
    total_quantity_sold,
    total_revenue,
    order_count,
    RANK() OVER (PARTITION BY address_state ORDER BY total_revenue DESC) AS state_rank
FROM regional_sales
ORDER BY address_state, state_rank;

-- Query 6.4: Regional Customer Segmentation
-- Uses: GROUP BY, CASE
SELECT
    c.address_state,
    c.customer_segment,
    COUNT(DISTINCT c.customer_id) AS customer_count,
    ROUND(COUNT(DISTINCT c.customer_id) * 100.0 / NULLIF(COUNT(DISTINCT c.customer_id) OVER (PARTITION BY c.address_state), 0), 2) AS segment_pct_in_state,
    SUM(o.total_amount) AS total_revenue,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY c.address_state, c.customer_segment
ORDER BY c.address_state, total_revenue DESC;

-- ============================================
-- 7. RFM ANALYSIS (RECENCY, FREQUENCY, MONETARY)
-- ============================================

-- Query 7.1: RFM Score Calculation
-- Uses: CTE, Window Functions, NTILE
WITH customer_rfm AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.email,
        -- Recency: Days since last purchase
        DATEDIFF(CURDATE(), MAX(o.order_date)) AS recency_days,
        -- Frequency: Count of orders
        COUNT(DISTINCT o.order_id) AS frequency_count,
        -- Monetary: Total spent
        SUM(o.total_amount) AS monetary_value
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.status IN ('Delivered', 'Shipped')
    GROUP BY c.customer_id, c.first_name, c.last_name, c.email
),
rfm_scores AS (
    SELECT
        customer_id,
        customer_name,
        email,
        recency_days,
        frequency_count,
        monetary_value,
        -- Recency Score (1-5, 5 being most recent)
        NTILE(5) OVER (ORDER BY recency_days ASC) AS recency_score,
        -- Frequency Score (1-5, 5 being most frequent)
        NTILE(5) OVER (ORDER BY frequency_count DESC) AS frequency_score,
        -- Monetary Score (1-5, 5 being highest value)
        NTILE(5) OVER (ORDER BY monetary_value DESC) AS monetary_score
    FROM customer_rfm
)
SELECT
    customer_id,
    customer_name,
    email,
    recency_days,
    frequency_count,
    ROUND(monetary_value, 2) AS monetary_value,
    recency_score,
    frequency_score,
    monetary_score,
    CONCAT(recency_score, frequency_score, monetary_score) AS rfm_score,
    recency_score + frequency_score + monetary_score AS rfm_total_score,
    CASE
        WHEN recency_score IN (4, 5) AND frequency_score IN (4, 5) AND monetary_score IN (4, 5) THEN 'Champions'
        WHEN recency_score IN (3, 4, 5) AND frequency_score IN (2, 3, 4, 5) THEN 'Loyal Customers'
        WHEN recency_score IN (4, 5) AND frequency_score IN (1, 2) THEN 'New Customers'
        WHEN recency_score IN (2, 3) AND frequency_score IN (2, 3) AND monetary_score IN (2, 3) THEN 'Potential Loyalists'
        WHEN recency_score IN (1, 2) AND frequency_score IN (4, 5) THEN 'At Risk'
        WHEN recency_score IN (1, 2) AND frequency_score IN (1, 2) AND monetary_score IN (4, 5) THEN 'Can\'t Lose Them'
        WHEN recency_score IN (3, 4) AND frequency_score IN (1, 2) THEN 'About to Sleep'
        ELSE 'Hibernating'
    END AS customer_segment
FROM rfm_scores
ORDER BY rfm_total_score DESC, monetary_value DESC;

-- ============================================
-- 8. PRODUCT RECOMMENDATION ANALYSIS
-- ============================================

-- Query 8.1: Frequently Bought Together (Market Basket Analysis)
-- Uses: Self JOIN, GROUP BY
SELECT
    p1.product_id AS product_1_id,
    p1.product_name AS product_1_name,
    p2.product_id AS product_2_id,
    p2.product_name AS product_2_name,
    COUNT(DISTINCT o1.order_id) AS times_bought_together,
    ROUND(COUNT(DISTINCT o1.order_id) * 100.0 / NULLIF(
        (SELECT COUNT(DISTINCT order_id) FROM order_items WHERE product_id = p1.product_id), 0
    ), 2) AS support_pct_for_product1,
    ROUND(COUNT(DISTINCT o1.order_id) * 100.0 / NULLIF(
        (SELECT COUNT(DISTINCT order_id) FROM order_items WHERE product_id = p2.product_id), 0
    ), 2) AS support_pct_for_product2
FROM order_items o1
JOIN order_items o2 ON o1.order_id = o2.order_id AND o1.product_id < o2.product_id
JOIN products p1 ON o1.product_id = p1.product_id
JOIN products p2 ON o2.product_id = p2.product_id
JOIN orders o ON o1.order_id = o.order_id
WHERE o.status IN ('Delivered', 'Shipped')
GROUP BY p1.product_id, p1.product_name, p2.product_id, p2.product_name
HAVING times_bought_together >= 2
ORDER BY times_bought_together DESC
LIMIT 20;

-- Query 8.2: Product Cross-Sell Opportunities
-- Uses: Subquery, LEFT JOIN
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.price,
    sales_stats.total_orders,
    sales_stats.total_revenue,
    cross_sell_suggestions.suggested_product_id,
    cross_sell_suggestions.suggested_product_name,
    cross_sell_suggestions.times_bought_together,
    cross_sell_suggestions.cross_sell_potential
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN (
    SELECT
        oi.product_id,
        COUNT(DISTINCT oi.order_id) AS total_orders,
        SUM(oi.total_price) AS total_revenue
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.status IN ('Delivered', 'Shipped')
    GROUP BY oi.product_id
) sales_stats ON p.product_id = sales_stats.product_id
LEFT JOIN (
    SELECT
        o1.product_id AS main_product_id,
        p2.product_id AS suggested_product_id,
        p2.product_name AS suggested_product_name,
        COUNT(DISTINCT o1.order_id) AS times_bought_together,
        ROUND(COUNT(DISTINCT o1.order_id) * 100.0 / NULLIF(
            (SELECT COUNT(DISTINCT order_id) FROM order_items WHERE product_id = o1.product_id), 0
        ), 2) AS cross_sell_potential
    FROM order_items o1
    JOIN order_items o2 ON o1.order_id = o2.order_id AND o1.product_id != o2.product_id
    JOIN products p2 ON o2.product_id = p2.product_id
    JOIN orders o ON o1.order_id = o.order_id
    WHERE o.status IN ('Delivered', 'Shipped')
    GROUP BY o1.product_id, p2.product_id, p2.product_name
) cross_sell_suggestions ON p.product_id = cross_sell_suggestions.main_product_id
WHERE sales_stats.total_orders >= 5
ORDER BY sales_stats.total_revenue DESC, cross_sell_suggestions.cross_sell_potential DESC
LIMIT 30;

-- Query 8.3: Customer Purchase History for Recommendations
-- Uses: Window Functions
WITH customer_purchases AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        oi.product_id,
        p.product_name,
        c.category_name,
        o.order_date,
        ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY o.order_date DESC) AS purchase_rank
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN categories cat ON p.category_id = cat.category_id
    WHERE o.status IN ('Delivered', 'Shipped')
),
last_purchases AS (
    SELECT
        customer_id,
        customer_name,
        product_id,
        product_name,
        category_name,
        order_date
    FROM customer_purchases
    WHERE purchase_rank <= 3
)
SELECT
    lp.customer_id,
    lp.customer_name,
    lp.product_id AS last_purchased_product_id,
    lp.product_name AS last_purchased_product_name,
    lp.category_name AS last_purchased_category,
    lp.order_date AS last_purchase_date,
    rec.product_id AS recommended_product_id,
    rec.product_name AS recommended_product_name,
    rec.category_name AS recommended_category,
    rec.times_bought_together,
    rec.cross_sell_probability
FROM last_purchases lp
LEFT JOIN (
    SELECT
        o1.product_id,
        p1.product_name,
        cat1.category_name,
        o2.product_id AS recommended_product_id,
        p2.product_name AS recommended_product_name,
        cat2.category_name AS recommended_category,
        COUNT(DISTINCT o1.order_id) AS times_bought_together,
        ROUND(COUNT(DISTINCT o1.order_id) * 100.0 / NULLIF(
            (SELECT COUNT(DISTINCT order_id) FROM order_items WHERE product_id = o1.product_id), 0
        ), 2) AS cross_sell_probability
    FROM order_items o1
    JOIN order_items o2 ON o1.order_id = o2.order_id AND o1.product_id != o2.product_id
    JOIN products p1 ON o1.product_id = p1.product_id
    JOIN products p2 ON o2.product_id = p2.product_id
    JOIN categories cat1 ON p1.category_id = cat1.category_id
    JOIN categories cat2 ON p2.category_id = cat2.category_id
    JOIN orders o ON o1.order_id = o.order_id
    WHERE o.status IN ('Delivered', 'Shipped')
    GROUP BY o1.product_id, p1.product_name, cat1.category_name, o2.product_id, p2.product_name, cat2.category_name
) rec ON lp.product_id = rec.product_id
WHERE lp.purchase_rank = 1
ORDER BY lp.customer_id, rec.cross_sell_probability DESC;

-- ============================================
-- 9. SALES FORECASTING QUERIES
-- ============================================

-- Query 9.1: Moving Average Sales (3-month)
-- Uses: Window Functions
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS year_month,
        SUM(o.total_amount) AS total_revenue,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM orders o
    WHERE o.status IN ('Delivered', 'Shipped')
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT
    year_month,
    total_revenue,
    total_orders,
    ROUND(AVG(total_revenue) OVER (
        ORDER BY year_month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3month_revenue,
    ROUND(AVG(total_orders) OVER (
        ORDER BY year_month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3month_orders,
    ROUND(total_revenue - AVG(total_revenue) OVER (
        ORDER BY year_month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS revenue_vs_3month_avg
FROM monthly_sales
ORDER BY year_month DESC;

-- Query 9.2: Year-over-Year Comparison
-- Uses: Window Functions, LAG
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS year_month,
        YEAR(o.order_date) AS year,
        MONTH(o.order_date) AS month,
        SUM(o.total_amount) AS total_revenue,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT o.customer_id) AS unique_customers
    FROM orders o
    WHERE o.status IN ('Delivered', 'Shipped')
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m'), YEAR(o.order_date), MONTH(o.order_date)
)
SELECT
    year_month,
    year,
    month,
    total_revenue,
    total_orders,
    unique_customers,
    LAG(total_revenue) OVER (PARTITION BY month ORDER BY year) AS prev_year_revenue,
    LAG(total_orders) OVER (PARTITION BY month ORDER BY year) AS prev_year_orders,
    ROUND((total_revenue - LAG(total_revenue) OVER (PARTITION BY month ORDER BY year)) /
          NULLIF(LAG(total_revenue) OVER (PARTITION BY month ORDER BY year), 0) * 100, 2) AS yoy_revenue_growth_pct,
    ROUND((total_orders - LAG(total_orders) OVER (PARTITION BY month ORDER BY year)) /
          NULLIF(LAG(total_orders) OVER (PARTITION BY month ORDER BY year), 0) * 100, 2) AS yoy_orders_growth_pct
FROM monthly_sales
ORDER BY year DESC, month DESC;

-- ============================================
-- 10. COMPREHENSIVE DASHBOARD QUERIES
-- ============================================

-- Query 10.1: Executive Summary KPIs
-- Uses: Multiple Aggregates, CTE
WITH overall_stats AS (
    SELECT
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT o.customer_id) AS unique_customers,
        SUM(o.total_amount) AS total_revenue,
        AVG(o.total_amount) AS avg_order_value,
        COUNT(DISTINCT c.customer_id) AS total_customers
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.status IN ('Delivered', 'Shipped')
),
period_stats AS (
    SELECT
        COUNT(DISTINCT o.order_id) AS period_orders,
        COUNT(DISTINCT o.customer_id) AS period_customers,
        SUM(o.total_amount) AS period_revenue
    FROM orders o
    WHERE o.status IN ('Delivered', 'Shipped')
      AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
),
product_stats AS (
    SELECT
        COUNT(DISTINCT p.product_id) AS total_products,
        COUNT(DISTINCT c.category_id) AS total_categories
    FROM products p
    JOIN categories c ON p.category_id = c.category_id
    WHERE p.is_active = TRUE
)
SELECT
    'Total Orders' AS metric,
    total_orders AS value,
    'count' AS unit
FROM overall_stats
UNION ALL
SELECT
    'Total Customers',
    total_customers,
    'count'
FROM overall_stats
UNION ALL
SELECT
    'Active Customers (30 days)',
    period_customers,
    'count'
FROM period_stats
UNION ALL
SELECT
    'Total Revenue',
    ROUND(total_revenue, 2),
    'USD'
FROM overall_stats
UNION ALL
SELECT
    'Revenue (30 days)',
    ROUND(period_revenue, 2),
    'USD'
FROM period_stats
UNION ALL
SELECT
    'Average Order Value',
    ROUND(avg_order_value, 2),
    'USD'
FROM overall_stats
UNION ALL
SELECT
    'Total Products',
    total_products,
    'count'
FROM product_stats
UNION ALL
SELECT
    'Total Categories',
    total_categories,
    'count'
FROM product_stats;

-- Query 10.2: Top Performing Categories
-- Uses: GROUP BY, RANK
WITH category_performance AS (
    SELECT
        c.category_name,
        COUNT(DISTINCT p.product_id) AS product_count,
        COUNT(DISTINCT oi.order_id) AS order_count,
        SUM(oi.quantity) AS total_quantity_sold,
        SUM(oi.total_price) AS total_revenue,
        AVG(p.rating_avg) AS avg_rating
    FROM categories c
    JOIN products p ON c.category_id = p.category_id
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    LEFT JOIN orders o ON oi.order_id = o.order_id AND o.status IN ('Delivered', 'Shipped')
    GROUP BY c.category_name
)
SELECT
    category_name,
    product_count,
    order_count,
    total_quantity_sold,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(total_revenue * 100.0 / NULLIF(SUM(total_revenue) OVER (), 0), 2) AS revenue_share_pct,
    ROUND(avg_rating, 2) AS avg_rating,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM category_performance
ORDER BY total_revenue DESC;

-- Query 10.3: Customer Segment Distribution
-- Uses: GROUP BY, Window Functions
SELECT
    customer_segment,
    COUNT(DISTINCT customer_id) AS customer_count,
    ROUND(COUNT(DISTINCT customer_id) * 100.0 / NULLIF(COUNT(DISTINCT customer_id) OVER (), 0), 2) AS customer_pct,
    SUM(total_orders) AS total_orders,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(SUM(total_revenue) * 100.0 / NULLIF(SUM(total_revenue) OVER (), 0), 2) AS revenue_share_pct,
    ROUND(AVG(avg_order_value), 2) AS avg_order_value
FROM (
    SELECT
        c.customer_id,
        c.customer_segment,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(o.total_amount) AS total_revenue,
        AVG(o.total_amount) AS avg_order_value
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.status IN ('Delivered', 'Shipped')
    GROUP BY c.customer_id, c.customer_segment
) segment_data
GROUP BY customer_segment
ORDER BY total_revenue DESC;
