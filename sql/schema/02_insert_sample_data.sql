-- ============================================
-- SAMPLE DATA INSERTION
-- ============================================
-- This script populates the database with realistic sample data

-- ============================================
-- 1. INSERT CATEGORIES
-- ============================================
INSERT INTO categories (category_id, category_name, parent_category_id, description) VALUES
(1, 'Electronics', NULL, 'Electronic devices and accessories'),
(2, 'Clothing', NULL, 'Apparel and fashion items'),
(3, 'Home & Garden', NULL, 'Home decor and gardening supplies'),
(4, 'Sports & Outdoors', NULL, 'Sports equipment and outdoor gear'),
(5, 'Books', NULL, 'Books and educational materials'),
(6, 'Smartphones', 1, 'Mobile phones and accessories'),
(7, 'Laptops', 1, 'Laptop computers and accessories'),
(8, 'Audio', 1, 'Audio equipment and headphones'),
(9, "Men's Clothing", 2, "Clothing for men"),
(10, "Women's Clothing", 2, "Clothing for women"),
(11, 'Furniture', 3, 'Home furniture'),
(12, 'Kitchen', 3, 'Kitchen appliances and tools'),
(13, 'Fitness', 4, 'Fitness equipment and accessories'),
(14, 'Team Sports', 4, 'Team sports equipment'),
(15, 'Fiction', 5, 'Fiction books'),
(16, 'Non-Fiction', 5, 'Non-fiction and educational books');

-- ============================================
-- 2. INSERT CUSTOMERS
-- ============================================
INSERT INTO customers (customer_id, first_name, last_name, email, phone, date_of_birth, gender, registration_date, last_login, address_street, address_city, address_state, address_zip, address_country, customer_segment, is_active, marketing_consent) VALUES
(1, 'John', 'Smith', 'john.smith@email.com', '555-0101', '1985-03-15', 'Male', '2023-01-15 09:30:00', '2024-12-10 14:22:00', '123 Main St', 'New York', 'NY', '10001', 'USA', 'Gold', TRUE, TRUE),
(2, 'Sarah', 'Johnson', 'sarah.j@email.com', '555-0102', '1990-07-22', 'Female', '2023-02-20 11:45:00', '2024-12-09 16:30:00', '456 Oak Ave', 'Los Angeles', 'CA', '90001', 'USA', 'Platinum', TRUE, TRUE),
(3, 'Michael', 'Williams', 'm.williams@email.com', '555-0103', '1988-11-08', 'Male', '2023-03-10 14:20:00', '2024-12-08 10:15:00', '789 Pine Rd', 'Chicago', 'IL', '60601', 'USA', 'Silver', TRUE, FALSE),
(4, 'Emily', 'Brown', 'emily.brown@email.com', '555-0104', '1992-05-30', 'Female', '2023-04-05 16:00:00', '2024-12-07 09:45:00', '321 Elm St', 'Houston', 'TX', '77001', 'USA', 'Gold', TRUE, TRUE),
(5, 'David', 'Jones', 'david.jones@email.com', '555-0105', '1987-09-12', 'Male', '2023-05-18 10:30:00', '2024-12-06 15:20:00', '654 Maple Dr', 'Phoenix', 'AZ', '85001', 'USA', 'Bronze', TRUE, FALSE),
(6, 'Jessica', 'Garcia', 'jessica.g@email.com', 'j.garcia@email.com', '555-0106', '1995-02-14', 'Female', '2023-06-22 13:15:00', '2024-12-05 11:30:00', '987 Cedar Ln', 'Philadelphia', 'PA', '19101', 'USA', 'Silver', TRUE, TRUE),
(7, 'Robert', 'Miller', 'r.miller@email.com', '555-0107', '1986-06-25', 'Male', '2023-07-08 09:00:00', '2024-12-04 14:10:00', '147 Birch Blvd', 'San Antonio', 'TX', '78201', 'USA', 'Bronze', TRUE, FALSE),
(8, 'Amanda', 'Davis', 'amanda.d@email.com', 'a.davis@email.com', '555-0108', '1993-12-03', 'Female', '2023-08-15 15:45:00', '2024-12-03 10:25:00', '258 Willow Way', 'San Diego', 'CA', '92101', 'USA', 'Gold', TRUE, TRUE),
(9, 'Christopher', 'Rodriguez', 'c.rodriguez@email.com', '555-0109', '1989-04-18', 'Male', '2023-09-20 11:30:00', '2024-12-02 16:40:00', '369 Aspen Ct', 'Dallas', 'TX', '75201', 'USA', 'Silver', TRUE, FALSE),
(10, 'Michelle', 'Martinez', 'm.martinez@email.com', '555-0110', '1991-08-27', 'Female', '2023-10-12 14:55:00', '2024-12-01 09:15:00', '741 Spruce St', 'San Jose', 'CA', '95101', 'USA', 'Platinum', TRUE, TRUE),
(11, 'Daniel', 'Hernandez', 'd.hernandez@email.com', '555-0111', '1984-01-09', 'Male', '2023-11-05 10:20:00', '2024-11-30 15:35:00', '852 Oak St', 'Austin', 'TX', '78701', 'USA', 'Gold', TRUE, TRUE),
(12, 'Lisa', 'Lopez', 'lisa.lopez@email.com', '555-0112', '1994-10-21', 'Female', '2023-12-01 13:40:00', '2024-11-29 11:50:00', '963 Pine Ave', 'Jacksonville', 'FL', '32201', 'USA', 'Bronze', TRUE, FALSE),
(13, 'Matthew', 'Gonzalez', 'm.gonzalez@email.com', '555-0113', '1988-03-16', 'Male', '2024-01-10 09:25:00', '2024-11-28 14:05:00', '174 Maple Dr', 'Fort Worth', 'TX', '76101', 'USA', 'Silver', TRUE, TRUE),
(14, 'Ashley', 'Wilson', 'ashley.w@email.com', '555-0114', '1992-07-08', 'Female', '2024-02-14 16:30:00', '2024-11-27 10:45:00', '285 Cedar Ln', 'Columbus', 'OH', '43201', 'USA', 'Gold', TRUE, TRUE),
(15, 'Joshua', 'Anderson', 'j.anderson@email.com', '555-0115', '1987-11-22', 'Male', '2024-03-20 11:15:00', '2024-11-26 15:20:00', '396 Birch Blvd', 'Charlotte', 'NC', '28201', 'USA', 'Bronze', TRUE, FALSE),
(16, 'Stephanie', 'Thomas', 's.thomas@email.com', '555-0116', '1995-05-04', 'Female', '2024-04-08 14:50:00', '2024-11-25 09:30:00', '417 Willow Way', 'San Francisco', 'CA', '94101', 'USA', 'Silver', TRUE, TRUE),
(17, 'Andrew', 'Taylor', 'a.taylor@email.com', '555-0117', '1986-09-30', 'Male', '2024-05-15 10:10:00', '2024-11-24 16:25:00', '528 Aspen Ct', 'Indianapolis', 'IN', '46201', 'USA', 'Gold', TRUE, FALSE),
(18, 'Jennifer', 'Moore', 'j.moore@email.com', '555-0118', '1993-02-12', 'Female', '2024-06-22 13:35:00', '2024-11-23 11:40:00', '639 Spruce St', 'Seattle', 'WA', '98101', 'USA', 'Platinum', TRUE, TRUE),
(19, 'Brandon', 'Jackson', 'b.jackson@email.com', '555-0119', '1989-06-18', 'Male', '2024-07-10 15:20:00', '2024-11-22 14:55:00', '740 Oak Ave', 'Denver', 'CO', '80201', 'USA', 'Silver', TRUE, TRUE),
(20, 'Nicole', 'White', 'nicole.white@email.com', '555-0120', '1991-04-25', 'Female', '2024-08-05 09:45:00', '2024-11-21 10:30:00', '851 Pine Rd', 'Boston', 'MA', '02101', 'USA', 'Gold', TRUE, FALSE);

-- ============================================
-- 3. INSERT PRODUCTS
-- ============================================
INSERT INTO products (product_id, product_name, sku, category_id, description, price, cost_price, stock_quantity, reorder_level, weight, brand, manufacturer, is_active) VALUES
-- Electronics - Smartphones
(1, 'iPhone 15 Pro Max', 'IP15PM-256', 6, 'Latest iPhone with A17 Pro chip, 256GB storage', 1199.99, 850.00, 45, 15, 0.28, 'Apple', 'Apple Inc.', TRUE),
(2, 'Samsung Galaxy S24 Ultra', 'SGS24U-512', 6, 'Premium Android smartphone with S Pen, 512GB', 1299.99, 900.00, 38, 12, 0.30, 'Samsung', 'Samsung Electronics', TRUE),
(3, 'Google Pixel 8 Pro', 'GP8P-256', 6, 'Google flagship with AI features, 256GB', 899.99, 600.00, 52, 15, 0.27, 'Google', 'Google LLC', TRUE),
(4, 'OnePlus 12', 'OP12-256', 6, 'Flagship killer with fast charging, 256GB', 799.99, 550.00, 60, 18, 0.26, 'OnePlus', 'OnePlus Technology', TRUE),
(5, 'Motorola Edge 40 Pro', 'ME40P-256', 6, 'Premium mid-range with great camera, 256GB', 699.99, 450.00, 55, 15, 0.25, 'Motorola', 'Motorola Mobility', TRUE),

-- Electronics - Laptops
(6, 'MacBook Pro 16" M3', 'MBP16M3-512', 7, 'Apple laptop with M3 Pro chip, 512GB SSD', 2499.99, 1800.00, 25, 8, 2.15, 'Apple', 'Apple Inc.', TRUE),
(7, 'Dell XPS 15', 'DXPS15-1TB', 7, 'Premium Windows laptop, 32GB RAM, 1TB SSD', 1899.99, 1300.00, 30, 10, 2.05, 'Dell', 'Dell Technologies', TRUE),
(8, 'HP Spectre x360', 'HPSX360-512', 7, 'Convertible 2-in-1 laptop, 16GB RAM, 512GB', 1499.99, 1000.00, 35, 12, 1.92, 'HP', 'HP Inc.', TRUE),
(9, 'Lenovo ThinkPad X1', 'LTPX1-1TB', 7, 'Business laptop, 32GB RAM, 1TB SSD', 1799.99, 1200.00, 28, 10, 1.88, 'Lenovo', 'Lenovo Group', TRUE),
(10, 'ASUS ROG Zephyrus', 'ARZ-1TB', 7, 'Gaming laptop with RTX 4080, 32GB RAM', 2199.99, 1500.00, 22, 8, 2.45, 'ASUS', 'ASUSTeK Computer', TRUE),

-- Electronics - Audio
(11, 'Sony WH-1000XM5', 'SWH1000XM5', 8, 'Premium noise-canceling headphones', 349.99, 200.00, 75, 20, 0.25, 'Sony', 'Sony Corporation', TRUE),
(12, 'AirPods Pro 2', 'APP2-USB', 8, 'Apple wireless earbuds with MagSafe case', 249.99, 150.00, 120, 30, 0.06, 'Apple', 'Apple Inc.', TRUE),
(13, 'Bose QuietComfort Ultra', 'BQCU', 8, 'Bose noise-canceling headphones', 329.99, 190.00, 68, 18, 0.24, 'Bose', 'Bose Corporation', TRUE),
(14, 'JBL Tour One M2', 'JBT1M2', 8, 'Premium headphones with great bass', 279.99, 160.00, 82, 22, 0.27, 'JBL', 'Harman International', TRUE),
(15, 'Sennheiser Momentum 4', 'SM4', 8, 'High-fidelity wireless headphones', 299.99, 180.00, 55, 15, 0.29, 'Sennheiser', 'Sennheiser Electronic', TRUE),

-- Clothing - Men's
(16, 'Levi 501 Original Jeans', 'L501-32-32', 9, 'Classic straight fit jeans', 69.99, 35.00, 200, 50, 0.68, 'Levi', 'Levi Strauss & Co.', TRUE),
(17, 'Nike Air Max 270', 'NAM270-10', 9, 'Comfortable running shoes', 129.99, 70.00, 150, 40, 0.85, 'Nike', 'Nike Inc.', TRUE),
(18, 'Ralph Lauren Polo Shirt', 'RLPS-M-L', 9, 'Classic cotton polo shirt', 89.99, 40.00, 180, 45, 0.25, 'Ralph Lauren', 'Ralph Lauren Corp', TRUE),
(19, 'Under Armour Hoodie', 'UAH-M-L', 9, 'Comfortable athletic hoodie', 59.99, 30.00, 220, 55, 0.65, 'Under Armour', 'Under Armour Inc.', TRUE),
(20, 'Carhartt Work Jacket', 'CWJ-M-L', 9, 'Durable work jacket', 99.99, 50.00, 95, 25, 0.95, 'Carhartt', 'Carhartt Inc.', TRUE),

-- Clothing - Women's
(21, 'Levi High Rise Jeans', 'LHR-28-30', 10, 'Women high-rise skinny jeans', 74.99, 38.00, 175, 45, 0.62, 'Levi', 'Levi Strauss & Co.', TRUE),
(22, 'Nike Air Force 1', 'NAF1-7', 10, 'Classic women sneakers', 109.99, 60.00, 165, 42, 0.72, 'Nike', 'Nike Inc.', TRUE),
(23, 'Lululemon Leggings', 'LL-6', 10, 'Premium yoga leggings', 98.99, 45.00, 140, 35, 0.28, 'Lululemon', 'Lululemon Athletica', TRUE),
(24, 'Zara Blouse', 'ZB-S', 10, 'Stylish women blouse', 49.99, 22.00, 250, 60, 0.22, 'Zara', 'Inditex', TRUE),
(25, 'Adidas Running Shoes', 'ARS-7', 10, 'Women running shoes', 119.99, 65.00, 155, 40, 0.68, 'Adidas', 'Adidas AG', TRUE),

-- Home & Garden - Furniture
(26, 'IKEA Hemnes Bed Frame', 'IHB-K', 11, 'Solid wood bed frame, King size', 299.99, 150.00, 30, 10, 45.0, 'IKEA', 'IKEA Group', TRUE),
(27, 'West Elm Sofa', 'WES-3S', 11, 'Modern 3-seater sofa', 1299.99, 700.00, 15, 5, 85.0, 'West Elm', 'Williams-Sonoma', TRUE),
(28, 'Wayfair Dining Table', 'WDT-6', 11, '6-seater dining table', 499.99, 250.00, 25, 8, 65.0, 'Wayfair', 'Wayfair Inc.', TRUE),
(29, 'Ashley Recliner', 'AR-CH', 11, 'Comfortable leather recliner', 599.99, 320.00, 20, 6, 55.0, 'Ashley', 'Ashley Furniture', TRUE),
(30, 'CB2 Bookshelf', 'CB2-5S', 11, 'Modern 5-shelf bookshelf', 349.99, 180.00, 35, 10, 40.0, 'CB2', 'CB2 LLC', TRUE),

-- Home & Garden - Kitchen
(31, 'Ninja Air Fryer', 'NAF-5.5QT', 12, '5.5QT air fryer with smart features', 149.99, 80.00, 80, 20, 12.5, 'Ninja', 'SharkNinja', TRUE),
(32, 'Instant Pot Duo', 'IPD-8QT', 12, '8-in-1 pressure cooker, 8QT', 119.99, 60.00, 95, 25, 14.2, 'Instant Pot', 'Instant Brands', TRUE),
(33, 'Breville Barista Express', 'BBE-870', 12, 'Espresso machine with grinder', 599.99, 350.00, 25, 8, 22.5, 'Breville', 'Breville Group', TRUE),
(34, 'Vitamix E310', 'VE310', 12, 'Professional blender', 349.99, 200.00, 45, 12, 10.8, 'Vitamix', 'Vitamix Corporation', TRUE),
(35, 'KitchenAid Stand Mixer', 'KASM-5QT', 12, '5-quart stand mixer', 449.99, 250.00, 40, 12, 26.5, 'KitchenAid', 'Whirlpool Corp', TRUE),

-- Sports & Outdoors - Fitness
(36, 'Peloton Bike+', 'PB+', 13, 'Connected fitness bike', 2495.00, 1500.00, 12, 4, 68.0, 'Peloton', 'Peloton Interactive', TRUE),
(37, 'NordicTrack Treadmill', 'NT-1750', 13, 'Commercial-grade treadmill', 1599.99, 900.00, 18, 5, 295.0, 'NordicTrack', 'iFIT Health & Fitness', TRUE),
(38, 'Bowflex SelectTech', 'BST-552', 13, 'Adjustable dumbbells 5-52.5 lbs', 449.99, 250.00, 60, 15, 52.5, 'Bowflex', 'Nautilus Inc.', TRUE),
(39, 'TRX Home2', 'TRXH2', 13, 'Suspension training system', 199.99, 100.00, 85, 20, 1.5, 'TRX', 'TRX Training', TRUE),
(40, 'Fitbit Charge 6', 'FC6', 13, 'Advanced fitness tracker', 159.99, 80.00, 120, 30, 0.15, 'Fitbit', 'Google LLC', TRUE),

-- Sports & Outdoors - Team Sports
(41, 'Wilson NBA Basketball', 'WNBA-29.5', 14, 'Official size basketball', 69.99, 35.00, 200, 50, 0.62, 'Wilson', 'Wilson Sporting Goods', TRUE),
(42, 'Adidas Soccer Ball', 'ASB-5', 14, 'Professional match ball', 49.99, 25.00, 250, 60, 0.43, 'Adidas', 'Adidas AG', TRUE),
(43, 'Rawlings Baseball Glove', 'RBG-12.5', 14, 'Pro-style baseball glove', 89.99, 45.00, 150, 40, 0.42, 'Rawlings', 'Rawlings Sporting Goods', TRUE),
(44, 'Nike Football', 'NF-Official', 14, 'Official NFL football', 119.99, 60.00, 100, 25, 0.95, 'Nike', 'Nike Inc.', TRUE),
(45, 'Yonex Tennis Racket', 'YTR-100', 14, 'Professional tennis racket', 199.99, 100.00, 80, 20, 0.30, 'Yonex', 'Yonex Co., Ltd.', TRUE),

-- Books - Fiction
(46, 'The Midnight Library', 'TML-978', 15, 'Bestselling novel by Matt Haig', 16.99, 8.00, 500, 100, 0.55, 'Penguin', 'Penguin Random House', TRUE),
(47, 'Project Hail Mary', 'PHM-978', 15, 'Sci-fi novel by Andy Weir', 18.99, 9.00, 450, 90, 0.62, 'Ballantine', 'Penguin Random House', TRUE),
(48, 'Where the Crawdads Sing', 'WTCS-978', 15, 'Mystery novel by Delia Owens', 17.99, 8.50, 480, 95, 0.58, 'Putnam', 'Penguin Random House', TRUE),
(49, 'The Silent Patient', 'TSP-978', 15, 'Psychological thriller', 16.99, 8.00, 520, 105, 0.52, 'Celadon', 'Macmillan', TRUE),
(50, 'Atomic Habits', 'AH-978', 16, 'Self-help book by James Clear', 18.99, 9.00, 600, 120, 0.48, 'Avery', 'Penguin Random House', TRUE);

-- ============================================
-- 4. INSERT ORDERS
-- ============================================
INSERT INTO orders (order_id, order_number, customer_id, order_date, required_date, shipped_date, delivery_date, status, subtotal, tax_amount, shipping_amount, discount_amount, total_amount, payment_method, payment_status, shipping_address_street, shipping_address_city, shipping_address_state, shipping_address_zip, shipping_address_country, tracking_number) VALUES
(1, 'ORD-2024-001', 1, '2024-01-15 10:30:00', '2024-01-20', '2024-01-16 14:00:00', '2024-01-19', 'Delivered', 1199.99, 95.99, 15.00, 0.00, 1310.98, 'Credit Card', 'Completed', '123 Main St', 'New York', 'NY', '10001', 'USA', 'TRK001234567'),
(2, 'ORD-2024-002', 2, '2024-01-18 14:22:00', '2024-01-25', '2024-01-19 10:00:00', '2024-01-23', 'Delivered', 2499.99, 199.99, 25.00, 249.99, 2474.99, 'PayPal', 'Completed', '456 Oak Ave', 'Los Angeles', 'CA', '90001', 'USA', 'TRK001234568'),
(3, 'ORD-2024-003', 3, '2024-01-22 09:15:00', '2024-01-30', '2024-01-23 11:30:00', '2024-01-28', 'Delivered', 349.99, 27.99, 12.00, 0.00, 389.98, 'Credit Card', 'Completed', '789 Pine Rd', 'Chicago', 'IL', '60601', 'USA', 'TRK001234569'),
(4, 'ORD-2024-004', 4, '2024-01-25 16:45:00', '2024-02-01', '2024-01-26 09:00:00', '2024-01-31', 'Delivered', 899.99, 71.99, 15.00, 89.99, 896.99, 'Debit Card', 'Completed', '321 Elm St', 'Houston', 'TX', '77001', 'USA', 'TRK001234570'),
(5, 'ORD-2024-005', 5, '2024-02-01 11:20:00', '2024-02-08', '2024-02-02 14:30:00', '2024-02-07', 'Delivered', 69.99, 5.59, 8.00, 0.00, 83.58, 'Credit Card', 'Completed', '654 Maple Dr', 'Phoenix', 'AZ', '85001', 'USA', 'TRK001234571'),
(6, 'ORD-2024-006', 6, '2024-02-05 13:30:00', '2024-02-12', '2024-02-06 10:15:00', '2024-02-11', 'Delivered', 129.99, 10.39, 10.00, 12.99, 137.39, 'PayPal', 'Completed', '987 Cedar Ln', 'Philadelphia', 'PA', '19101', 'USA', 'TRK001234572'),
(7, 'ORD-2024-007', 7, '2024-02-10 15:00:00', '2024-02-17', '2024-02-11 13:45:00', '2024-02-16', 'Delivered', 59.99, 4.79, 8.00, 0.00, 72.78, 'Credit Card', 'Completed', '147 Birch Blvd', 'San Antonio', 'TX', '78201', 'USA', 'TRK001234573'),
(8, 'ORD-2024-008', 8, '2024-02-15 09:45:00', '2024-02-22', '2024-02-16 11:20:00', '2024-02-21', 'Delivered', 249.99, 19.99, 12.00, 24.99, 256.99, 'Credit Card', 'Completed', '258 Willow Way', 'San Diego', 'CA', '92101', 'USA', 'TRK001234574'),
(9, 'ORD-2024-009', 9, '2024-02-20 14:10:00', '2024-02-27', '2024-02-21 10:00:00', '2024-02-26', 'Delivered', 1899.99, 151.99, 25.00, 189.99, 1886.99, 'PayPal', 'Completed', '369 Aspen Ct', 'Dallas', 'TX', '75201', 'USA', 'TRK001234575'),
(10, 'ORD-2024-010', 10, '2024-02-25 10:55:00', '2024-03-03', '2024-02-26 14:30:00', '2024-03-02', 'Delivered', 1299.99, 103.99, 20.00, 129.99, 1293.99, 'Credit Card', 'Completed', '741 Spruce St', 'San Jose', 'CA', '95101', 'USA', 'TRK001234576'),
(11, 'ORD-2024-011', 11, '2024-03-01 11:30:00', '2024-03-08', '2024-03-02 09:15:00', '2024-03-07', 'Delivered', 329.99, 26.39, 12.00, 0.00, 368.38, 'Credit Card', 'Completed', '852 Oak St', 'Austin', 'TX', '78701', 'USA', 'TRK001234577'),
(12, 'ORD-2024-012', 12, '2024-03-05 13:40:00', '2024-03-12', '2024-03-06 11:25:00', '2024-03-11', 'Delivered', 74.99, 5.99, 8.00, 7.49, 81.49, 'Debit Card', 'Completed', '963 Pine Ave', 'Jacksonville', 'FL', '32201', 'USA', 'TRK001234578'),
(13, 'ORD-2024-013', 13, '2024-03-10 09:25:00', '2024-03-17', '2024-03-11 14:50:00', '2024-03-16', 'Delivered', 149.99, 11.99, 10.00, 0.00, 171.98, 'Credit Card', 'Completed', '174 Maple Dr', 'Fort Worth', 'TX', '76101', 'USA', 'TRK001234579'),
(14, 'ORD-2024-014', 14, '2024-03-15 16:30:00', '2024-03-22', '2024-03-16 10:40:00', '2024-03-21', 'Delivered', 599.99, 47.99, 25.00, 59.99, 612.99, 'PayPal', 'Completed', '285 Cedar Ln', 'Columbus', 'OH', '43201', 'USA', 'TRK001234580'),
(15, 'ORD-2024-015', 15, '2024-03-20 11:15:00', '2024-03-27', '2024-03-21 13:20:00', '2024-03-26', 'Delivered', 99.99, 7.99, 12.00, 0.00, 119.98, 'Credit Card', 'Completed', '396 Birch Blvd', 'Charlotte', 'NC', '28201', 'USA', 'TRK001234581'),
(16, 'ORD-2024-016', 16, '2024-03-25 14:50:00', '2024-04-01', '2024-03-26 09:30:00', '2024-03-31', 'Delivered', 119.99, 9.59, 10.00, 11.99, 117.59, 'Credit Card', 'Completed', '417 Willow Way', 'San Francisco', 'CA', '94101', 'USA', 'TRK001234582'),
(17, 'ORD-2024-017', 17, '2024-04-01 10:10:00', '2024-04-08', '2024-04-02 14:15:00', '2024-04-07', 'Delivered', 1799.99, 143.99, 25.00, 179.99, 1788.99, 'PayPal', 'Completed', '528 Aspen Ct', 'Indianapolis', 'IN', '46201', 'USA', 'TRK001234583'),
(18, 'ORD-2024-018', 18, '2024-04-05 13:35:00', '2024-04-12', '2024-04-06 11:50:00', '2024-04-11', 'Delivered', 2495.00, 199.60, 50.00, 249.50, 2495.10, 'Credit Card', 'Completed', '639 Spruce St', 'Seattle', 'WA', '98101', 'USA', 'TRK001234584'),
(19, 'ORD-2024-019', 19, '2024-04-10 15:20:00', '2024-04-17', '2024-04-11 10:25:00', '2024-04-16', 'Delivered', 1599.99, 127.99, 30.00, 159.99, 1597.99, 'PayPal', 'Completed', '740 Oak Ave', 'Denver', 'CO', '80201', 'USA', 'TRK001234585'),
(20, 'ORD-2024-020', 20, '2024-04-15 09:45:00', '2024-04-22', '2024-04-16 14:30:00', '2024-04-21', 'Delivered', 349.99, 27.99, 12.00, 34.99, 354.99, 'Credit Card', 'Completed', '851 Pine Rd', 'Boston', 'MA', '02101', 'USA', 'TRK001234586'),
(21, 'ORD-2024-021', 1, '2024-05-01 10:30:00', '2024-05-08', '2024-05-02 11:00:00', '2024-05-07', 'Delivered', 279.99, 22.39, 12.00, 0.00, 314.38, 'Credit Card', 'Completed', '123 Main St', 'New York', 'NY', '10001', 'USA', 'TRK001234587'),
(22, 'ORD-2024-022', 2, '2024-05-05 14:22:00', '2024-05-12', '2024-05-06 13:45:00', '2024-05-11', 'Delivered', 449.99, 35.99, 15.00, 44.99, 455.99, 'PayPal', 'Completed', '456 Oak Ave', 'Los Angeles', 'CA', '90001', 'USA', 'TRK001234588'),
(23, 'ORD-2024-023', 3, '2024-05-10 09:15:00', '2024-05-17', '2024-05-11 10:30:00', '2024-05-16', 'Delivered', 89.99, 7.19, 8.00, 0.00, 105.18, 'Credit Card', 'Completed', '789 Pine Rd', 'Chicago', 'IL', '60601', 'USA', 'TRK001234589'),
(24, 'ORD-2024-024', 4, '2024-05-15 16:45:00', '2024-05-22', '2024-05-16 14:00:00', '2024-05-21', 'Delivered', 799.99, 63.99, 15.00, 79.99, 798.99, 'Debit Card', 'Completed', '321 Elm St', 'Houston', 'TX', '77001', 'USA', 'TRK001234590'),
(25, 'ORD-2024-025', 5, '2024-05-20 11:20:00', '2024-05-27', '2024-05-21 09:15:00', '2024-05-26', 'Delivered', 49.99, 3.99, 8.00, 0.00, 61.98, 'Credit Card', 'Completed', '654 Maple Dr', 'Phoenix', 'AZ', '85001', 'USA', 'TRK001234591'),
(26, 'ORD-2024-026', 6, '2024-06-01 13:30:00', '2024-06-08', '2024-06-02 11:45:00', '2024-06-07', 'Delivered', 109.99, 8.79, 10.00, 10.99, 107.79, 'PayPal', 'Completed', '987 Cedar Ln', 'Philadelphia', 'PA', '19101', 'USA', 'TRK001234592'),
(27, 'ORD-2024-027', 7, '2024-06-05 15:00:00', '2024-06-12', '2024-06-06 10:30:00', '2024-06-11', 'Delivered', 98.99, 7.91, 8.00, 9.89, 105.01, 'Credit Card', 'Completed', '147 Birch Blvd', 'San Antonio', 'TX', '78201', 'USA', 'TRK001234593'),
(28, 'ORD-2024-028', 8, '2024-06-10 09:45:00', '2024-06-17', '2024-06-11 14:20:00', '2024-06-16', 'Delivered', 299.99, 23.99, 12.00, 29.99, 305.99, 'Credit Card', 'Completed', '258 Willow Way', 'San Diego', 'CA', '92101', 'USA', 'TRK001234594'),
(29, 'ORD-2024-029', 9, '2024-06-15 14:10:00', '2024-06-22', '2024-06-16 11:55:00', '2024-06-21', 'Delivered', 1499.99, 119.99, 25.00, 149.99, 1494.99, 'PayPal', 'Completed', '369 Aspen Ct', 'Dallas', 'TX', '75201', 'USA', 'TRK001234595'),
(30, 'ORD-2024-030', 10, '2024-06-20 10:55:00', '2024-06-27', '2024-06-21 13:40:00', '2024-06-26', 'Delivered', 2199.99, 175.99, 30.00, 219.99, 2185.99, 'Credit Card', 'Completed', '741 Spruce St', 'San Jose', 'CA', '95101', 'USA', 'TRK001234596'),
(31, 'ORD-2024-031', 11, '2024-07-01 11:30:00', '2024-07-08', '2024-07-02 10:15:00', '2024-07-07', 'Delivered', 199.99, 15.99, 12.00, 0.00, 227.98, 'Credit Card', 'Completed', '852 Oak St', 'Austin', 'TX', '78701', 'USA', 'TRK001234597'),
(32, 'ORD-2024-032', 12, '2024-07-05 13:40:00', '2024-07-12', '2024-07-06 14:25:00', '2024-07-11', 'Delivered', 16.99, 1.35, 5.00, 0.00, 23.34, 'Debit Card', 'Completed', '963 Pine Ave', 'Jacksonville', 'FL', '32201', 'USA', 'TRK001234598'),
(33, 'ORD-2024-033', 13, '2024-07-10 09:25:00', '2024-07-17', '2024-07-11 11:50:00', '2024-07-16', 'Delivered', 119.99, 9.59, 10.00, 11.99, 117.59, 'Credit Card', 'Completed', '174 Maple Dr', 'Fort Worth', 'TX', '76101', 'USA', 'TRK001234599'),
(34, 'ORD-2024-034', 14, '2024-07-15 16:30:00', '2024-07-22', '2024-07-16 09:40:00', '2024-07-21', 'Delivered', 499.99, 39.99, 20.00, 49.99, 509.99, 'PayPal', 'Completed', '285 Cedar Ln', 'Columbus', 'OH', '43201', 'USA', 'TRK001234600'),
(35, 'ORD-2024-035', 15, '2024-07-20 11:15:00', '2024-07-27', '2024-07-21 13:20:00', '2024-07-26', 'Delivered', 69.99, 5.59, 8.00, 0.00, 83.58, 'Credit Card', 'Completed', '396 Birch Blvd', 'Charlotte', 'NC', '28201', 'USA', 'TRK001234601'),
(36, 'ORD-2024-036', 16, '2024-08-01 14:50:00', '2024-08-08', '2024-08-02 10:30:00', '2024-08-07', 'Delivered', 159.99, 12.79, 10.00, 15.99, 156.79, 'Credit Card', 'Completed', '417 Willow Way', 'San Francisco', 'CA', '94101', 'USA', 'TRK001234602'),
(37, 'ORD-2024-037', 17, '2024-08-05 10:10:00', '2024-08-12', '2024-08-06 14:45:00', '2024-08-11', 'Delivered', 349.99, 27.99, 12.00, 34.99, 354.99, 'PayPal', 'Completed', '528 Aspen Ct', 'Indianapolis', 'IN', '46201', 'USA', 'TRK001234603'),
(38, 'ORD-2024-038', 18, '2024-08-10 13:35:00', '2024-08-17', '2024-08-11 11:20:00', '2024-08-16', 'Delivered', 449.99, 35.99, 15.00, 44.99, 455.99, 'Credit Card', 'Completed', '639 Spruce St', 'Seattle', 'WA', '98101', 'USA', 'TRK001234604'),
(39, 'ORD-2024-039', 19, '2024-08-15 15:20:00', '2024-08-22', '2024-08-16 10:55:00', '2024-08-21', 'Delivered', 89.99, 7.19, 8.00, 0.00, 105.18, 'PayPal', 'Completed', '740 Oak Ave', 'Denver', 'CO', '80201', 'USA', 'TRK001234605'),
(40, 'ORD-2024-040', 20, '2024-08-20 09:45:00', '2024-08-27', '2024-08-21 13:30:00', '2024-08-26', 'Delivered', 299.99, 23.99, 12.00, 29.99, 305.99, 'Credit Card', 'Completed', '851 Pine Rd', 'Boston', 'MA', '02101', 'USA', 'TRK001234606'),
(41, 'ORD-2024-041', 1, '2024-09-01 10:30:00', '2024-09-08', '2024-09-02 11:15:00', '2024-09-07', 'Delivered', 599.99, 47.99, 25.00, 59.99, 612.99, 'Credit Card', 'Completed', '123 Main St', 'New York', 'NY', '10001', 'USA', 'TRK001234607'),
(42, 'ORD-2024-042', 2, '2024-09-05 14:22:00', '2024-09-12', '2024-09-06 10:40:00', '2024-09-11', 'Delivered', 1299.99, 103.99, 20.00, 129.99, 1293.99, 'PayPal', 'Completed', '456 Oak Ave', 'Los Angeles', 'CA', '90001', 'USA', 'TRK001234608'),
(43, 'ORD-2024-043', 3, '2024-09-10 09:15:00', '2024-09-17', '2024-09-11 14:25:00', '2024-09-16', 'Delivered', 249.99, 19.99, 12.00, 0.00, 281.98, 'Credit Card', 'Completed', '789 Pine Rd', 'Chicago', 'IL', '60601', 'USA', 'TRK001234609'),
(44, 'ORD-2024-044', 4, '2024-09-15 16:45:00', '2024-09-22', '2024-09-16 11:50:00', '2024-09-21', 'Delivered', 699.99, 55.99, 15.00, 69.99, 695.99, 'Debit Card', 'Completed', '321 Elm St', 'Houston', 'TX', '77001', 'USA', 'TRK001234610'),
(45, 'ORD-2024-045', 5, '2024-09-20 11:20:00', '2024-09-27', '2024-09-21 13:35:00', '2024-09-26', 'Delivered', 18.99, 1.51, 5.00, 0.00, 25.50, 'Credit Card', 'Completed', '654 Maple Dr', 'Phoenix', 'AZ', '85001', 'USA', 'TRK001234611'),
(46, 'ORD-2024-046', 6, '2024-10-01 13:30:00', '2024-10-08', '2024-10-02 10:15:00', '2024-10-07', 'Delivered', 16.99, 1.35, 5.00, 0.00, 23.34, 'PayPal', 'Completed', '987 Cedar Ln', 'Philadelphia', 'PA', '19101', 'USA', 'TRK001234612'),
(47, 'ORD-2024-047', 7, '2024-10-05 15:00:00', '2024-10-12', '2024-10-06 14:40:00', '2024-10-11', 'Delivered', 17.99, 1.43, 5.00, 0.00, 24.42, 'Credit Card', 'Completed', '147 Birch Blvd', 'San Antonio', 'TX', '78201', 'USA', 'TRK001234613'),
(48, 'ORD-2024-048', 8, '2024-10-10 09:45:00', '2024-10-17', '2024-10-11 11:55:00', '2024-10-16', 'Delivered', 349.99, 27.99, 12.00, 34.99, 354.99, 'Credit Card', 'Completed', '258 Willow Way', 'San Diego', 'CA', '92101', 'USA', 'TRK001234614'),
(49, 'ORD-2024-049', 9, '2024-10-15 14:10:00', '2024-10-22', '2024-10-16 10:30:00', '2024-10-21', 'Delivered', 159.99, 12.79, 10.00, 15.99, 156.79, 'PayPal', 'Completed', '369 Aspen Ct', 'Dallas', 'TX', '75201', 'USA', 'TRK001234615'),
(50, 'ORD-2024-050', 10, '2024-10-20 10:55:00', '2024-10-27', '2024-10-21 13:45:00', '2024-10-26', 'Delivered', 1199.99, 95.99, 15.00, 119.99, 1194.99, 'Credit Card', 'Completed', '741 Spruce St', 'San Jose', 'CA', '95101', 'USA', 'TRK001234616'),
(51, 'ORD-2024-051', 11, '2024-11-01 11:30:00', '2024-11-08', '2024-11-02 10:20:00', '2024-11-07', 'Delivered', 279.99, 22.39, 12.00, 0.00, 314.38, 'Credit Card', 'Completed', '852 Oak St', 'Austin', 'TX', '78701', 'USA', 'TRK001234617'),
(52, 'ORD-2024-052', 12, '2024-11-05 13:40:00', '2024-11-12', '2024-11-06 14:55:00', '2024-11-11', 'Delivered', 49.99, 3.99, 8.00, 0.00, 61.98, 'Debit Card', 'Completed', '963 Pine Ave', 'Jacksonville', 'FL', '32201', 'USA', 'TRK001234618'),
(53, 'ORD-2024-053', 13, '2024-11-10 09:25:00', '2024-11-17', '2024-11-11 11:40:00', '2024-11-16', 'Delivered', 89.99, 7.19, 8.00, 0.00, 105.18, 'Credit Card', 'Completed', '174 Maple Dr', 'Fort Worth', 'TX', '76101', 'USA', 'TRK001234619'),
(54, 'ORD-2024-054', 14, '2024-11-15 16:30:00', '2024-11-22', '2024-11-16 10:25:00', '2024-11-21', 'Delivered', 299.99, 23.99, 12.00, 29.99, 305.99, 'PayPal', 'Completed', '285 Cedar Ln', 'Columbus', 'OH', '43201', 'USA', 'TRK001234620'),
(55, 'ORD-2024-055', 15, '2024-11-20 11:15:00', '2024-11-27', '2024-11-21 13:50:00', '2024-11-26', 'Delivered', 109.99, 8.79, 10.00, 10.99, 107.79, 'Credit Card', 'Completed', '396 Birch Blvd', 'Charlotte', 'NC', '28201', 'USA', 'TRK001234621'),
(56, 'ORD-2024-056', 16, '2024-12-01 14:50:00', '2024-12-08', '2024-12-02 11:35:00', '2024-12-07', 'Delivered', 599.99, 47.99, 25.00, 59.99, 612.99, 'Credit Card', 'Completed', '417 Willow Way', 'San Francisco', 'CA', '94101', 'USA', 'TRK001234622'),
(57, 'ORD-2024-057', 17, '2024-12-05 10:10:00', '2024-12-12', '2024-12-06 14:20:00', '2024-12-11', 'Delivered', 2495.00, 199.60, 50.00, 249.50, 2495.10, 'PayPal', 'Completed', '528 Aspen Ct', 'Indianapolis', 'IN', '46201', 'USA', 'TRK001234623'),
(58, 'ORD-2024-058', 18, '2024-12-10 13:35:00', '2024-12-17', '2024-12-11 10:45:00', '2024-12-16', 'Delivered', 1899.99, 151.99, 25.00, 189.99, 1886.99, 'Credit Card', 'Completed', '639 Spruce St', 'Seattle', 'WA', '98101', 'USA', 'TRK001234624'),
(59, 'ORD-2024-059', 19, '2024-12-15 15:20:00', '2024-12-22', '2024-12-16 13:10:00', '2024-12-21', 'Delivered', 449.99, 35.99, 15.00, 44.99, 455.99, 'PayPal', 'Completed', '740 Oak Ave', 'Denver', 'CO', '80201', 'USA', 'TRK001234625'),
(60, 'ORD-2024-060', 20, '2024-12-20 09:45:00', '2024-12-27', '2024-12-21 11:55:00', '2024-12-26', 'Delivered', 1299.99, 103.99, 20.00, 129.99, 1293.99, 'Credit Card', 'Completed', '851 Pine Rd', 'Boston', 'MA', '02101', 'USA', 'TRK001234626');

-- ============================================
-- 5. INSERT ORDER_ITEMS
-- ============================================
INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_percent) VALUES
-- Order 1
(1, 1, 1, 1199.99, 0),
-- Order 2
(2, 6, 1, 2499.99, 10),
-- Order 3
(3, 11, 1, 349.99, 0),
-- Order 4
(4, 3, 1, 899.99, 10),
-- Order 5
(5, 16, 1, 69.99, 0),
-- Order 6
(6, 17, 1, 129.99, 10),
-- Order 7
(7, 19, 1, 59.99, 0),
-- Order 8
(8, 12, 1, 249.99, 10),
-- Order 9
(9, 7, 1, 1899.99, 10),
-- Order 10
(10, 10, 1, 1299.99, 10),
-- Order 11
(11, 13, 1, 329.99, 0),
-- Order 12
(12, 21, 1, 74.99, 10),
-- Order 13
(13, 31, 1, 149.99, 0),
-- Order 14
(14, 33, 1, 599.99, 10),
-- Order 15
(15, 20, 1, 99.99, 0),
-- Order 16
(16, 22, 1, 109.99, 10),
-- Order 17
(17, 9, 1, 1799.99, 10),
-- Order 18
(18, 36, 1, 2495.00, 10),
-- Order 19
(19, 37, 1, 1599.99, 10),
-- Order 20
(20, 11, 1, 349.99, 10),
-- Order 21
(21, 14, 1, 279.99, 0),
-- Order 22
(22, 35, 1, 449.99, 10),
-- Order 23
(23, 18, 1, 89.99, 0),
-- Order 24
(24, 4, 1, 799.99, 10),
-- Order 25
(25, 24, 1, 49.99, 0),
-- Order 26
(26, 25, 1, 109.99, 10),
-- Order 27
(27, 23, 1, 98.99, 10),
-- Order 28
(28, 15, 1, 299.99, 10),
-- Order 29
(29, 8, 1, 1499.99, 10),
-- Order 30
(30, 10, 1, 2199.99, 10),
-- Order 31
(31, 45, 1, 199.99, 0),
-- Order 32
(32, 46, 1, 16.99, 0),
-- Order 33
(33, 12, 1, 119.99, 10),
-- Order 34
(34, 28, 1, 499.99, 10),
-- Order 35
(35, 16, 1, 69.99, 0),
-- Order 36
(36, 17, 1, 159.99, 10),
-- Order 37
(37, 11, 1, 349.99, 10),
-- Order 38
(38, 35, 1, 449.99, 10),
-- Order 39
(39, 18, 1, 89.99, 0),
-- Order 40
(40, 15, 1, 299.99, 10),
-- Order 41
(41, 14, 1, 599.99, 10),
-- Order 42
(42, 10, 1, 1299.99, 10),
-- Order 43
(43, 12, 1, 249.99, 0),
-- Order 44
(44, 5, 1, 699.99, 10),
-- Order 45
(45, 47, 1, 18.99, 0),
-- Order 46
(46, 46, 1, 16.99, 0),
-- Order 47
(47, 48, 1, 17.99, 0),
-- Order 48
(48, 11, 1, 349.99, 10),
-- Order 49
(49, 14, 1, 159.99, 10),
-- Order 50
(50, 1, 1, 1199.99, 10),
-- Order 51
(51, 14, 1, 279.99, 0),
-- Order 52
(52, 24, 1, 49.99, 0),
-- Order 53
(53, 18, 1, 89.99, 0),
-- Order 54
(54, 15, 1, 299.99, 10),
-- Order 55
(55, 22, 1, 109.99, 10),
-- Order 56
(56, 14, 1, 599.99, 10),
-- Order 57
(57, 36, 1, 2495.00, 10),
-- Order 58
(58, 7, 1, 1899.99, 10),
-- Order 59
(59, 35, 1, 449.99, 10),
-- Order 60
(60, 10, 1, 1299.99, 10);

-- ============================================
-- 6. INSERT PAYMENTS
-- ============================================
INSERT INTO payments (payment_id, order_id, payment_date, payment_method, amount, currency, transaction_id, payment_status, gateway_response) VALUES
(1, 1, '2024-01-15 10:35:00', 'Credit Card', 1310.98, 'USD', 'TXN-2024-001', 'Completed', 'Payment successful'),
(2, 2, '2024-01-18 14:27:00', 'PayPal', 2474.99, 'USD', 'TXN-2024-002', 'Completed', 'Payment successful'),
(3, 3, '2024-01-22 09:20:00', 'Credit Card', 389.98, 'USD', 'TXN-2024-003', 'Completed', 'Payment successful'),
(4, 4, '2024-01-25 16:50:00', 'Debit Card', 896.99, 'USD', 'TXN-2024-004', 'Completed', 'Payment successful'),
(5, 5, '2024-02-01 11:25:00', 'Credit Card', 83.58, 'USD', 'TXN-2024-005', 'Completed', 'Payment successful'),
(6, 6, '2024-02-05 13:35:00', 'PayPal', 137.39, 'USD', 'TXN-2024-006', 'Completed', 'Payment successful'),
(7, 7, '2024-02-10 15:05:00', 'Credit Card', 72.78, 'USD', 'TXN-2024-007', 'Completed', 'Payment successful'),
(8, 8, '2024-02-15 09:50:00', 'Credit Card', 256.99, 'USD', 'TXN-2024-008', 'Completed', 'Payment successful'),
(9, 9, '2024-02-20 14:15:00', 'PayPal', 1886.99, 'USD', 'TXN-2024-009', 'Completed', 'Payment successful'),
(10, 10, '2024-02-25 11:00:00', 'Credit Card', 1293.99, 'USD', 'TXN-2024-010', 'Completed', 'Payment successful'),
(11, 11, '2024-03-01 11:35:00', 'Credit Card', 368.38, 'USD', 'TXN-2024-011', 'Completed', 'Payment successful'),
(12, 12, '2024-03-05 13:45:00', 'Debit Card', 81.49, 'USD', 'TXN-2024-012', 'Completed', 'Payment successful'),
(13, 13, '2024-03-10 09:30:00', 'Credit Card', 171.98, 'USD', 'TXN-2024-013', 'Completed', 'Payment successful'),
(14, 14, '2024-03-15 16:35:00', 'PayPal', 612.99, 'USD', 'TXN-2024-014', 'Completed', 'Payment successful'),
(15, 15, '2024-03-20 11:20:00', 'Credit Card', 119.98, 'USD', 'TXN-2024-015', 'Completed', 'Payment successful'),
(16, 16, '2024-03-25 14:55:00', 'Credit Card', 117.59, 'USD', 'TXN-2024-016', 'Completed', 'Payment successful'),
(17, 17, '2024-04-01 10:15:00', 'PayPal', 1788.99, 'USD', 'TXN-2024-017', 'Completed', 'Payment successful'),
(18, 18, '2024-04-05 13:40:00', 'Credit Card', 2495.10, 'USD', 'TXN-2024-018', 'Completed', 'Payment successful'),
(19, 19, '2024-04-10 15:25:00', 'PayPal', 1597.99, 'USD', 'TXN-2024-019', 'Completed', 'Payment successful'),
(20, 20, '2024-04-15 09:50:00', 'Credit Card', 354.99, 'USD', 'TXN-2024-020', 'Completed', 'Payment successful'),
(21, 21, '2024-05-01 10:35:00', 'Credit Card', 314.38, 'USD', 'TXN-2024-021', 'Completed', 'Payment successful'),
(22, 22, '2024-05-05 14:27:00', 'PayPal', 455.99, 'USD', 'TXN-2024-022', 'Completed', 'Payment successful'),
(23, 23, '2024-05-10 09:20:00', 'Credit Card', 105.18, 'USD', 'TXN-2024-023', 'Completed', 'Payment successful'),
(24, 24, '2024-05-15 16:50:00', 'Debit Card', 798.99, 'USD', 'TXN-2024-024', 'Completed', 'Payment successful'),
(25, 25, '2024-05-20 11:25:00', 'Credit Card', 61.98, 'USD', 'TXN-2024-025', 'Completed', 'Payment successful'),
(26, 26, '2024-06-01 13:35:00', 'PayPal', 107.79, 'USD', 'TXN-2024-026', 'Completed', 'Payment successful'),
(27, 27, '2024-06-05 15:05:00', 'Credit Card', 105.01, 'USD', 'TXN-2024-027', 'Completed', 'Payment successful'),
(28, 28, '2024-06-10 09:50:00', 'Credit Card', 305.99, 'USD', 'TXN-2024-028', 'Completed', 'Payment successful'),
(29, 29, '2024-06-15 14:15:00', 'PayPal', 1494.99, 'USD', 'TXN-2024-029', 'Completed', 'Payment successful'),
(30, 30, '2024-06-20 11:00:00', 'Credit Card', 2185.99, 'USD', 'TXN-2024-030', 'Completed', 'Payment successful'),
(31, 31, '2024-07-01 11:35:00', 'Credit Card', 227.98, 'USD', 'TXN-2024-031', 'Completed', 'Payment successful'),
(32, 32, '2024-07-05 13:45:00', 'Debit Card', 23.34, 'USD', 'TXN-2024-032', 'Completed', 'Payment successful'),
(33, 33, '2024-07-10 09:30:00', 'Credit Card', 117.59, 'USD', 'TXN-2024-033', 'Completed', 'Payment successful'),
(34, 34, '2024-07-15 16:35:00', 'PayPal', 509.99, 'USD', 'TXN-2024-034', 'Completed', 'Payment successful'),
(35, 35, '2024-07-20 11:20:00', 'Credit Card', 83.58, 'USD', 'TXN-2024-035', 'Completed', 'Payment successful'),
(36, 36, '2024-08-01 14:55:00', 'Credit Card', 156.79, 'USD', 'TXN-2024-036', 'Completed', 'Payment successful'),
(37, 37, '2024-08-05 10:15:00', 'PayPal', 354.99, 'USD', 'TXN-2024-037', 'Completed', 'Payment successful'),
(38, 38, '2024-08-10 13:40:00', 'Credit Card', 455.99, 'USD', 'TXN-2024-038', 'Completed', 'Payment successful'),
(39, 39, '2024-08-15 15:25:00', 'PayPal', 105.18, 'USD', 'TXN-2024-039', 'Completed', 'Payment successful'),
(40, 40, '2024-08-20 09:50:00', 'Credit Card', 305.99, 'USD', 'TXN-2024-040', 'Completed', 'Payment successful'),
(41, 41, '2024-09-01 10:35:00', 'Credit Card', 612.99, 'USD', 'TXN-2024-041', 'Completed', 'Payment successful'),
(42, 42, '2024-09-05 14:27:00', 'PayPal', 1293.99, 'USD', 'TXN-2024-042', 'Completed', 'Payment successful'),
(43, 43, '2024-09-10 09:20:00', 'Credit Card', 281.98, 'USD', 'TXN-2024-043', 'Completed', 'Payment successful'),
(44, 44, '2024-09-15 16:50:00', 'Debit Card', 695.99, 'USD', 'TXN-2024-044', 'Completed', 'Payment successful'),
(45, 45, '2024-09-20 11:25:00', 'Credit Card', 25.50, 'USD', 'TXN-2024-045', 'Completed', 'Payment successful'),
(46, 46, '2024-10-01 13:35:00', 'PayPal', 23.34, 'USD', 'TXN-2024-046', 'Completed', 'Payment successful'),
(47, 47, '2024-10-05 15:05:00', 'Credit Card', 24.42, 'USD', 'TXN-2024-047', 'Completed', 'Payment successful'),
(48, 48, '2024-10-10 09:50:00', 'Credit Card', 354.99, 'USD', 'TXN-2024-048', 'Completed', 'Payment successful'),
(49, 49, '2024-10-15 14:15:00', 'PayPal', 156.79, 'USD', 'TXN-2024-049', 'Completed', 'Payment successful'),
(50, 50, '2024-10-20 11:00:00', 'Credit Card', 1194.99, 'USD', 'TXN-2024-050', 'Completed', 'Payment successful'),
(51, 51, '2024-11-01 11:35:00', 'Credit Card', 314.38, 'USD', 'TXN-2024-051', 'Completed', 'Payment successful'),
(52, 52, '2024-11-05 13:45:00', 'Debit Card', 61.98, 'USD', 'TXN-2024-052', 'Completed', 'Payment successful'),
(53, 53, '2024-11-10 09:30:00', 'Credit Card', 105.18, 'USD', 'TXN-2024-053', 'Completed', 'Payment successful'),
(54, 54, '2024-11-15 16:35:00', 'PayPal', 305.99, 'USD', 'TXN-2024-054', 'Completed', 'Payment successful'),
(55, 55, '2024-11-20 11:20:00', 'Credit Card', 107.79, 'USD', 'TXN-2024-055', 'Completed', 'Payment successful'),
(56, 56, '2024-12-01 14:55:00', 'Credit Card', 612.99, 'USD', 'TXN-2024-056', 'Completed', 'Payment successful'),
(57, 57, '2024-12-05 10:15:00', 'PayPal', 2495.10, 'USD', 'TXN-2024-057', 'Completed', 'Payment successful'),
(58, 58, '2024-12-10 13:40:00', 'Credit Card', 1886.99, 'USD', 'TXN-2024-058', 'Completed', 'Payment successful'),
(59, 59, '2024-12-15 15:25:00', 'PayPal', 455.99, 'USD', 'TXN-2024-059', 'Completed', 'Payment successful'),
(60, 60, '2024-12-20 09:50:00', 'Credit Card', 1293.99, 'USD', 'TXN-2024-060', 'Completed', 'Payment successful');

-- ============================================
-- 7. INSERT REVIEWS
-- ============================================
INSERT INTO reviews (review_id, order_id, product_id, customer_id, rating, review_title, review_text, is_verified_purchase, helpful_count) VALUES
(1, 1, 1, 1, 5, 'Amazing phone!', 'Best iPhone ever. The camera is incredible and battery life is amazing.', TRUE, 12),
(2, 2, 6, 2, 5, 'Perfect for work', 'Great laptop for development work. Fast and reliable.', TRUE, 8),
(3, 3, 11, 3, 4, 'Great noise cancellation', 'Excellent headphones for work from home. Very comfortable.', TRUE, 5),
(4, 4, 3, 4, 4, 'Good Android phone', 'Solid phone with great AI features. Camera could be better.', TRUE, 3),
(5, 5, 16, 5, 5, 'Classic fit', 'Best jeans ever. Perfect fit and great quality.', TRUE, 7),
(6, 6, 17, 6, 4, 'Comfortable shoes', 'Great running shoes. Very comfortable for long runs.', TRUE, 4),
(7, 7, 19, 7, 4, 'Good hoodie', 'Nice and warm. Good quality for the price.', TRUE, 2),
(8, 8, 12, 8, 5, 'Best earbuds', 'Amazing sound quality and the case is great.', TRUE, 9),
(9, 9, 7, 9, 5, 'Excellent laptop', 'Best Windows laptop I have owned. Great display and performance.', TRUE, 6),
(10, 10, 10, 10, 5, 'Gaming beast', 'Perfect for gaming. RTX 4080 is incredible.', TRUE, 11),
(11, 11, 13, 11, 4, 'Good headphones', 'Great sound quality but a bit expensive.', TRUE, 3),
(12, 12, 21, 12, 5, 'Perfect fit', 'Love these jeans. Great quality and fit.', TRUE, 5),
(13, 13, 31, 13, 5, 'Best air fryer', 'Amazing air fryer. Cooks everything perfectly.', TRUE, 8),
(14, 14, 33, 14, 5, 'Great espresso', 'Best coffee I have made at home. Worth every penny.', TRUE, 7),
(15, 15, 20, 15, 4, 'Good jacket', 'Durable and warm. Good for work.', TRUE, 2),
(16, 16, 22, 16, 5, 'Classic sneakers', 'Love these shoes. Very comfortable.', TRUE, 4),
(17, 17, 9, 17, 5, 'Business laptop', 'Perfect for business. Great keyboard and trackpad.', TRUE, 6),
(18, 18, 36, 18, 5, 'Life changing', 'Best investment for fitness. Love the classes.', TRUE, 15),
(19, 19, 37, 19, 4, 'Great treadmill', 'Solid treadmill. Good for home workouts.', TRUE, 5),
(20, 20, 11, 20, 4, 'Good headphones', 'Great for travel. Noise cancellation works well.', TRUE, 3),
(21, 21, 14, 1, 4, 'Good bass', 'Great headphones with amazing bass.', TRUE, 4),
(22, 22, 35, 2, 5, 'Best mixer', 'Amazing mixer. Makes baking so much easier.', TRUE, 6),
(23, 23, 18, 3, 4, 'Good polo', 'Nice quality polo. Good fit.', TRUE, 2),
(24, 24, 4, 4, 4, 'Good phone', 'Great value for money. Fast charging is amazing.', TRUE, 3),
(25, 25, 24, 5, 3, 'Okay blouse', 'Nice but runs a bit small.', TRUE, 1),
(26, 26, 25, 6, 4, 'Good running shoes', 'Comfortable and lightweight.', TRUE, 3),
(27, 27, 23, 7, 5, 'Best leggings', 'Most comfortable leggings I own.', TRUE, 7),
(28, 28, 15, 8, 4, 'Good headphones', 'Great sound quality.', TRUE, 2),
(29, 29, 8, 9, 5, 'Great 2-in-1', 'Perfect for work and travel. Great battery life.', TRUE, 5),
(30, 30, 10, 10, 5, 'Amazing gaming laptop', 'Best for gaming. Runs everything smoothly.', TRUE, 9),
(31, 31, 45, 11, 4, 'Good racket', 'Great for tennis. Good grip.', TRUE, 2),
(32, 32, 46, 12, 5, 'Amazing book', 'Could not put it down. Highly recommend.', TRUE, 8),
(33, 33, 12, 13, 5, 'Best earbuds', 'Perfect for workouts. Stay in place well.', TRUE, 4),
(34, 34, 28, 14, 4, 'Good table', 'Nice dining table. Good quality.', TRUE, 3),
(35, 35, 16, 15, 5, 'Love these jeans', 'Best jeans ever. Will buy again.', TRUE, 5),
(36, 36, 17, 16, 4, 'Good shoes', 'Comfortable and stylish.', TRUE, 2),
(37, 37, 11, 17, 4, 'Good headphones', 'Great for work. Good noise cancellation.', TRUE, 3),
(38, 38, 35, 18, 5, 'Best mixer', 'Love this mixer. Makes cooking fun.', TRUE, 6),
(39, 39, 18, 19, 4, 'Good polo', 'Nice quality. Good fit.', TRUE, 2),
(40, 40, 15, 20, 4, 'Good headphones', 'Great sound. Comfortable.', TRUE, 3),
(41, 41, 14, 1, 5, 'Amazing headphones', 'Best headphones I have owned.', TRUE, 6),
(42, 42, 10, 2, 5, 'Gaming laptop', 'Perfect for gaming. Great performance.', TRUE, 8),
(43, 43, 12, 3, 5, 'Best earbuds', 'Amazing sound quality.', TRUE, 5),
(44, 44, 5, 4, 4, 'Good phone', 'Great value. Good camera.', TRUE, 3),
(45, 45, 47, 5, 5, 'Amazing book', 'Best sci-fi I have read in years.', TRUE, 9),
(46, 46, 46, 6, 4, 'Good book', 'Interesting story. Good read.', TRUE, 3),
(47, 47, 48, 7, 5, 'Loved it', 'Beautiful story. Could not stop reading.', TRUE, 7),
(48, 48, 11, 8, 4, 'Good headphones', 'Great for travel.', TRUE, 2),
(49, 49, 14, 9, 4, 'Good headphones', 'Nice sound. Good bass.', TRUE, 3),
(50, 50, 1, 10, 5, 'Best phone', 'Amazing iPhone. Love the new features.', TRUE, 10),
(51, 51, 14, 11, 4, 'Good headphones', 'Great quality. Good price.', TRUE, 2),
(52, 52, 24, 12, 3, 'Okay blouse', 'Nice but sizing is off.', TRUE, 1),
(53, 53, 18, 13, 4, 'Good polo', 'Nice quality. Good fit.', TRUE, 2),
(54, 54, 15, 14, 4, 'Good headphones', 'Great sound. Comfortable.', TRUE, 3),
(55, 55, 22, 15, 5, 'Love these shoes', 'Most comfortable sneakers.', TRUE, 4),
(56, 56, 14, 16, 5, 'Amazing headphones', 'Best purchase this year.', TRUE, 7),
(57, 57, 36, 17, 5, 'Best fitness investment', 'Changed my life. Love the classes.', TRUE, 12),
(58, 58, 7, 18, 5, 'Great laptop', 'Perfect for work. Fast and reliable.', TRUE, 6),
(59, 59, 35, 19, 5, 'Best mixer', 'Makes baking so much easier.', TRUE, 5),
(60, 60, 10, 20, 5, 'Gaming beast', 'Best gaming laptop. Runs everything.', TRUE, 9);

-- ============================================
-- UPDATE PRODUCT RATINGS
-- ============================================
CALL sp_update_product_rating(1);
CALL sp_update_product_rating(2);
CALL sp_update_product_rating(3);
CALL sp_update_product_rating(4);
CALL sp_update_product_rating(5);
CALL sp_update_product_rating(6);
CALL sp_update_product_rating(7);
CALL sp_update_product_rating(8);
CALL sp_update_product_rating(9);
CALL sp_update_product_rating(10);
CALL sp_update_product_rating(11);
CALL sp_update_product_rating(12);
CALL sp_update_product_rating(13);
CALL sp_update_product_rating(14);
CALL sp_update_product_rating(15);
CALL sp_update_product_rating(16);
CALL sp_update_product_rating(17);
CALL sp_update_product_rating(18);
CALL sp_update_product_rating(19);
CALL sp_update_product_rating(20);
CALL sp_update_product_rating(21);
CALL sp_update_product_rating(22);
CALL sp_update_product_rating(23);
CALL sp_update_product_rating(24);
CALL sp_update_product_rating(25);
CALL sp_update_product_rating(28);
CALL sp_update_product_rating(31);
CALL sp_update_product_rating(33);
CALL sp_update_product_rating(35);
CALL sp_update_product_rating(36);
CALL sp_update_product_rating(45);
CALL sp_update_product_rating(46);
CALL sp_update_product_rating(47);
CALL sp_update_product_rating(48);

-- ============================================
-- UPDATE CUSTOMER SEGMENTS
-- ============================================
CALL sp_update_customer_segment(1);
CALL sp_update_customer_segment(2);
CALL sp_update_customer_segment(3);
CALL sp_update_customer_segment(4);
CALL sp_update_customer_segment(5);
CALL sp_update_customer_segment(6);
CALL sp_update_customer_segment(7);
CALL sp_update_customer_segment(8);
CALL sp_update_customer_segment(9);
CALL sp_update_customer_segment(10);
CALL sp_update_customer_segment(11);
CALL sp_update_customer_segment(12);
CALL sp_update_customer_segment(13);
CALL sp_update_customer_segment(14);
CALL sp_update_customer_segment(15);
CALL sp_update_customer_segment(16);
CALL sp_update_customer_segment(17);
CALL sp_update_customer_segment(18);
CALL sp_update_customer_segment(19);
CALL sp_update_customer_segment(20);
