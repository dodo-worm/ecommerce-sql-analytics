-- ============================================
-- E-COMMERCE DATABASE SCHEMA
-- ============================================
-- Database: ecommerce_analytics
-- Description: Complete relational schema for e-commerce analytics

-- Drop existing tables if they exist (for clean setup)
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;

-- ============================================
-- 1. CUSTOMERS TABLE
-- ============================================
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other'),
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME,
    address_street VARCHAR(200),
    address_city VARCHAR(50),
    address_state VARCHAR(50),
    address_zip VARCHAR(20),
    address_country VARCHAR(50) DEFAULT 'USA',
    customer_segment ENUM('Bronze', 'Silver', 'Gold', 'Platinum') DEFAULT 'Bronze',
    is_active BOOLEAN DEFAULT TRUE,
    marketing_consent BOOLEAN DEFAULT FALSE,
    INDEX idx_email (email),
    INDEX idx_registration_date (registration_date),
    INDEX idx_city (address_city),
    INDEX idx_segment (customer_segment)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 2. CATEGORIES TABLE
-- ============================================
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    parent_category_id INT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
    INDEX idx_parent (parent_category_id),
    INDEX idx_name (category_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 3. PRODUCTS TABLE
-- ============================================
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(200) NOT NULL,
    sku VARCHAR(50) UNIQUE NOT NULL,
    category_id INT NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    cost_price DECIMAL(10, 2),
    stock_quantity INT DEFAULT 0,
    reorder_level INT DEFAULT 10,
    weight DECIMAL(5, 2),
    dimensions VARCHAR(50),
    color VARCHAR(30),
    size VARCHAR(20),
    brand VARCHAR(50),
    manufacturer VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    rating_avg DECIMAL(3, 2) DEFAULT 0,
    review_count INT DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    INDEX idx_sku (sku),
    INDEX idx_category (category_id),
    INDEX idx_price (price),
    INDEX idx_brand (brand),
    INDEX idx_rating (rating_avg)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 4. ORDERS TABLE
-- ============================================
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    required_date DATE,
    shipped_date DATETIME,
    delivery_date DATETIME,
    status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled', 'Returned') DEFAULT 'Pending',
    subtotal DECIMAL(12, 2) NOT NULL,
    tax_amount DECIMAL(10, 2) DEFAULT 0,
    shipping_amount DECIMAL(10, 2) DEFAULT 0,
    discount_amount DECIMAL(10, 2) DEFAULT 0,
    total_amount DECIMAL(12, 2) NOT NULL,
    payment_method ENUM('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer', 'Cash on Delivery'),
    payment_status ENUM('Pending', 'Completed', 'Failed', 'Refunded') DEFAULT 'Pending',
    shipping_address_street VARCHAR(200),
    shipping_address_city VARCHAR(50),
    shipping_address_state VARCHAR(50),
    shipping_address_zip VARCHAR(20),
    shipping_address_country VARCHAR(50),
    tracking_number VARCHAR(100),
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE RESTRICT,
    INDEX idx_customer (customer_id),
    INDEX idx_order_date (order_date),
    INDEX idx_status (status),
    INDEX idx_order_number (order_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 5. ORDER_ITEMS TABLE (Junction for Orders-Products)
-- ============================================
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL,
    discount_percent DECIMAL(5, 2) DEFAULT 0,
    total_price DECIMAL(12, 2) GENERATED ALWAYS AS (quantity * unit_price * (1 - discount_percent/100)) STORED,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT,
    INDEX idx_order (order_id),
    INDEX idx_product (product_id),
    UNIQUE KEY uk_order_product (order_id, product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 6. PAYMENTS TABLE
-- ============================================
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer', 'Cash on Delivery') NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    transaction_id VARCHAR(100) UNIQUE,
    payment_status ENUM('Pending', 'Completed', 'Failed', 'Refunded') DEFAULT 'Pending',
    gateway_response TEXT,
    refund_amount DECIMAL(12, 2) DEFAULT 0,
    refund_date DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    INDEX idx_order (order_id),
    INDEX idx_payment_date (payment_date),
    INDEX idx_status (payment_status),
    INDEX idx_transaction (transaction_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 7. REVIEWS TABLE
-- ============================================
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_title VARCHAR(200),
    review_text TEXT,
    is_verified_purchase BOOLEAN DEFAULT TRUE,
    helpful_count INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    INDEX idx_product (product_id),
    INDEX idx_customer (customer_id),
    INDEX idx_rating (rating),
    INDEX idx_created (created_at),
    UNIQUE KEY uk_order_product_review (order_id, product_id, customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- VIEWS FOR COMMON ANALYTICS
-- ============================================

-- View: Order Summary with Customer Details
CREATE VIEW v_order_summary AS
SELECT
    o.order_id,
    o.order_number,
    o.order_date,
    o.status,
    o.total_amount,
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    c.address_city,
    c.address_state,
    COUNT(oi.order_item_id) AS item_count,
    SUM(oi.quantity) AS total_quantity
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_number, o.order_date, o.status, o.total_amount,
         c.customer_id, c.first_name, c.last_name, c.email, c.address_city, c.address_state;

-- View: Product Sales Summary
CREATE VIEW v_product_sales AS
SELECT
    p.product_id,
    p.product_name,
    p.sku,
    c.category_name,
    p.price,
    COUNT(DISTINCT oi.order_id) AS order_count,
    SUM(oi.quantity) AS total_sold,
    SUM(oi.total_price) AS total_revenue,
    AVG(r.rating) AS avg_rating,
    COUNT(r.review_id) AS review_count
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name, p.sku, c.category_name, p.price;

-- ============================================
-- STORED PROCEDURES
-- ============================================

DELIMITER //

-- Procedure: Update Product Rating
CREATE PROCEDURE sp_update_product_rating(IN p_product_id INT)
BEGIN
    UPDATE products p
    SET
        rating_avg = (SELECT AVG(rating) FROM reviews WHERE product_id = p_product_id),
        review_count = (SELECT COUNT(*) FROM reviews WHERE product_id = p_product_id)
    WHERE product_id = p_product_id;
END //

-- Procedure: Update Customer Segment
CREATE PROCEDURE sp_update_customer_segment(IN p_customer_id INT)
BEGIN
    DECLARE total_spent DECIMAL(12, 2);
    DECLARE order_count INT;

    SELECT
        COALESCE(SUM(total_amount), 0),
        COUNT(*)
    INTO total_spent, order_count
    FROM orders
    WHERE customer_id = p_customer_id
    AND status IN ('Delivered', 'Shipped');

    UPDATE customers
    SET customer_segment =
        CASE
            WHEN total_spent >= 10000 OR order_count >= 20 THEN 'Platinum'
            WHEN total_spent >= 5000 OR order_count >= 10 THEN 'Gold'
            WHEN total_spent >= 1000 OR order_count >= 5 THEN 'Silver'
            ELSE 'Bronze'
        END
    WHERE customer_id = p_customer_id;
END //

DELIMITER ;
