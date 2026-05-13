# ============================================
# 1. IMPORT LIBRARIES
# ============================================
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from datetime import datetime, timedelta
import warnings
warnings.filterwarnings('ignore')

# Set style
plt.style.use('seaborn-v0_8-darkgrid')
sns.set_palette("husl")

# Display settings
pd.set_option('display.max_columns', None)
pd.set_option('display.width', None)
pd.set_option('display.max_colwidth', 50)

# ============================================
# 2. DATA LOADING
# ============================================
# For this project, we'll use SQLite with the SQL schema
import sqlite3
import os

# Create database connection
db_path = '../data/sql/ecommerce.db'
conn = sqlite3.connect(db_path)

# Function to load data from SQL
def load_table(table_name):
    """Load a table from SQLite database into pandas DataFrame."""
    query = f"SELECT * FROM {table_name}"
    return pd.read_sql_query(query, conn)

# Load all tables
customers_df = load_table('customers')
orders_df = load_table('orders')
products_df = load_table('products')
categories_df = load_table('categories')
order_items_df = load_table('order_items')
payments_df = load_table('payments')
reviews_df = load_table('reviews')

print("Data loaded successfully!")
print(f"\nCustomers: {customers_df.shape[0]} rows, {customers_df.shape[1]} columns")
print(f"Orders: {orders_df.shape[0]} rows, {orders_df.shape[1]} columns")
print(f"Products: {products_df.shape[0]} rows, {products_df.shape[1]} columns")
print(f"Categories: {categories_df.shape[0]} rows, {categories_df.shape[1]} columns")
print(f"Order Items: {order_items_df.shape[0]} rows, {order_items_df.shape[1]} columns")
print(f"Payments: {payments_df.shape[0]} rows, {payments_df.shape[1]} columns")
print(f"Reviews: {reviews_df.shape[0]} rows, {reviews_df.shape[1]} columns")

# ============================================
# 3. DATA OVERVIEW
# ============================================

# Display first few rows of each table
print("=== CUSTOMERS TABLE ===")
print(customers_df.head())

print("\n=== ORDERS TABLE ===")
print(orders_df.head())

print("\n=== PRODUCTS TABLE ===")
print(products_df.head())

print("\n=== ORDER ITEMS TABLE ===")
print(order_items_df.head())

# ============================================
# 4. MISSING VALUES ANALYSIS
# ============================================

def analyze_missing_values(df, table_name):
    """Analyze and display missing values in a DataFrame."""
    missing = df.isnull().sum()
    missing_pct = (missing / len(df)) * 100

    missing_df = pd.DataFrame({
        'Column': df.columns,
        'Missing Count': missing.values,
        'Missing %': missing_pct.values
    })

    missing_df = missing_df[missing_df['Missing Count'] > 0].sort_values('Missing Count', ascending=False)

    if len(missing_df) > 0:
        print(f"\n=== {table_name} - Missing Values ===")
        print(missing_df)
    else:
        print(f"\n{table_name}: No missing values found!")

    return missing_df

# Analyze missing values for all tables
for df, name in [(customers_df, 'Customers'), (orders_df, 'Orders'),
                (products_df, 'Products'), (order_items_df, 'Order Items'),
                (payments_df, 'Payments'), (reviews_df, 'Reviews')]:
    analyze_missing_values(df, name)

# ============================================
# 5. SALES TRENDS ANALYSIS
# ============================================

# Convert date columns to datetime
orders_df['order_date'] = pd.to_datetime(orders_df['order_date'])
orders_df['shipped_date'] = pd.to_datetime(orders_df['shipped_date'])
orders_df['delivery_date'] = pd.to_datetime(orders_df['delivery_date'])

# Filter for completed orders
completed_orders = orders_df[orders_df['status'].isin(['Delivered', 'Shipped'])].copy()

# Extract date components
completed_orders['year'] = completed_orders['order_date'].dt.year
completed_orders['month'] = completed_orders['order_date'].dt.month
completed_orders['year_month'] = completed_orders['order_date'].dt.to_period('M')
completed_orders['day_of_week'] = completed_orders['order_date'].dt.day_name()
completed_orders['hour'] = completed_orders['order_date'].dt.hour

# Monthly revenue trend
monthly_revenue = completed_orders.groupby('year_month').agg({
    'order_id': 'count',
    'customer_id': 'nunique',
    'total_amount': ['sum', 'mean']
}).reset_index()
monthly_revenue.columns = ['Year-Month', 'Total Orders', 'Unique Customers', 'Total Revenue', 'Avg Order Value']

print("=== Monthly Revenue Trend ===")
print(monthly_revenue)

# ============================================
# 6. CUSTOMER SEGMENTATION ANALYSIS
# ============================================

# Customer segment distribution
segment_counts = customers_df['customer_segment'].value_counts()
segment_pct = (segment_counts / len(customers_df)) * 100

print("=== Customer Segment Distribution ===")
segment_df = pd.DataFrame({'Count': segment_counts, 'Percentage': segment_pct})
print(segment_df)

# Revenue by customer segment
segment_revenue = completed_orders.merge(customers_df[['customer_id', 'customer_segment']],
                                          on='customer_id', how='left')
segment_revenue_stats = segment_revenue.groupby('customer_segment').agg({
    'order_id': 'count',
    'customer_id': 'nunique',
    'total_amount': ['sum', 'mean', 'std']
}).reset_index()
segment_revenue_stats.columns = ['Segment', 'Orders', 'Customers', 'Total Revenue',
                                 'Avg Order Value', 'Std Dev']

print("\n=== Revenue by Customer Segment ===")
print(segment_revenue_stats)

# ============================================
# 7. PRODUCT PERFORMANCE ANALYSIS
# ============================================

# Merge order items with products and categories
product_sales = order_items_df.merge(products_df[['product_id', 'product_name', 'category_id', 'price']],
                                      on='product_id', how='left')
product_sales = product_sales.merge(categories_df[['category_id', 'category_name']],
                                      on='category_id', how='left')
product_sales = product_sales.merge(orders_df[['order_id', 'status']],
                                      on='order_id', how='left')

# Filter for completed orders
product_sales = product_sales[product_sales['status'].isin(['Delivered', 'Shipped'])]

# Top 10 products by revenue
top_products_revenue = product_sales.groupby(['product_id', 'product_name', 'category_name']).agg({
    'order_id': 'nunique',
    'quantity': 'sum',
    'total_price': 'sum'
}).reset_index()
top_products_revenue.columns = ['Product ID', 'Product Name', 'Category',
                                'Order Count', 'Quantity Sold', 'Total Revenue']
top_products_revenue = top_products_revenue.sort_values('Total Revenue', ascending=False).head(10)

print("=== Top 10 Products by Revenue ===")
print(top_products_revenue)

# Category performance
category_performance = product_sales.groupby('category_name').agg({
    'product_id': 'nunique',
    'order_id': 'nunique',
    'quantity': 'sum',
    'total_price': 'sum'
}).reset_index()
category_performance.columns = ['Category', 'Unique Products', 'Order Count',
                                'Quantity Sold', 'Total Revenue']
category_performance = category_performance.sort_values('Total Revenue', ascending=False)

print("\n=== Category Performance ===")
print(category_performance)

# ============================================
# 8. CORRELATION ANALYSIS
# ============================================

# Create a comprehensive dataset for correlation analysis
customer_stats = completed_orders.groupby('customer_id').agg({
    'order_id': 'count',
    'total_amount': ['sum', 'mean', 'std', 'min', 'max'],
    'order_date': ['min', 'max']
}).reset_index()
customer_stats.columns = ['customer_id', 'order_count', 'total_spent', 'avg_order_value',
                          'std_order_value', 'min_order_value', 'max_order_value',
                          'first_order_date', 'last_order_date']

# Add customer segment
customer_stats = customer_stats.merge(customers_df[['customer_id', 'customer_segment']],
                                        on='customer_id', how='left')

# Calculate days as customer
customer_stats['days_as_customer'] = (customer_stats['last_order_date'] -
                                        customer_stats['first_order_date']).dt.days

# Calculate days since last order
customer_stats['days_since_last_order'] = (datetime.now() -
                                              customer_stats['last_order_date']).dt.days

# Encode customer segment
segment_mapping = {'Bronze': 1, 'Silver': 2, 'Gold': 3, 'Platinum': 4}
customer_stats['segment_encoded'] = customer_stats['customer_segment'].map(segment_mapping)

# Select numeric columns for correlation
numeric_cols = ['order_count', 'total_spent', 'avg_order_value', 'std_order_value',
                'min_order_value', 'max_order_value', 'days_as_customer',
                'days_since_last_order', 'segment_encoded']
correlation_df = customer_stats[numeric_cols].copy()

# Calculate correlation matrix
correlation_matrix = correlation_df.corr()

print("=== Correlation Matrix ===")
print(correlation_matrix)

# ============================================
# 9. SUMMARY AND KEY INSIGHTS
# ============================================

print("=" * 60)
print("E-COMMERCE ANALYTICS - EDA SUMMARY")
print("=" * 60)

print("\n📊 DATASET OVERVIEW")
print(f"- Total Customers: {len(customers_df):,}")
print(f"- Total Orders: {len(orders_df):,}")
print(f"- Completed Orders: {len(completed_orders):,}")
print(f"- Total Products: {len(products_df):,}")
print(f"- Total Categories: {len(categories_df):,}")
print(f"- Total Reviews: {len(reviews_df):,}")

print("\n💰 REVENUE METRICS")
print(f"- Total Revenue: ${completed_orders['total_amount'].sum():,.2f}")
print(f"- Average Order Value: ${completed_orders['total_amount'].mean():,.2f}")
print(f"- Median Order Value: ${completed_orders['total_amount'].median():,.2f}")

print("\n👥 CUSTOMER METRICS")
print(f"- Unique Customers with Orders: {completed_orders['customer_id'].nunique():,}")
print(f"- Average Orders per Customer: {len(completed_orders) / completed_orders['customer_id'].nunique():.2f}")

print("\n🏆 TOP PERFORMERS")
print(f"- Best Selling Category: {category_performance.iloc[0]['Category']}")
print(f"- Top Product by Revenue: {top_products_revenue.iloc[0]['Product Name']}")

print("\n" + "=" * 60)
print("EDA COMPLETE!")
print("=" * 60)

# ============================================
# 10. EXPORT PROCESSED DATA FOR FEATURE ENGINEERING
# ============================================

# Create processed data directory
os.makedirs('../data/processed', exist_ok=True)

# Export key datasets for feature engineering
customer_stats.to_csv('../data/processed/customer_stats.csv', index=False)
product_sales.to_csv('../data/processed/product_sales.csv', index=False)
monthly_revenue.to_csv('../data/processed/monthly_revenue.csv', index=False)
category_performance.to_csv('../data/processed/category_performance.csv', index=False)

print("\nProcessed data exported successfully!")
