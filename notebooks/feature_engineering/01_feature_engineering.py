# ============================================
# E-COMMERCE CUSTOMER ANALYTICS - FEATURE ENGINEERING
# ============================================
# This notebook performs feature engineering for ML models

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

# ============================================
# 1. LOAD DATA
# ============================================
import sqlite3
import os

# Create database connection
db_path = 'data/sql/ecommerce.db'
conn = sqlite3.connect(db_path)

# Load data
customers_df = pd.read_sql_query("SELECT * FROM customers", conn)
orders_df = pd.read_sql_query("SELECT * FROM orders", conn)
products_df = pd.read_sql_query("SELECT * FROM products", conn)
categories_df = pd.read_sql_query("SELECT * FROM categories", conn)
order_items_df = pd.read_sql_query("SELECT * FROM order_items", conn)
reviews_df = pd.read_sql_query("SELECT * FROM reviews", conn)

print("Data loaded successfully!")

# ============================================
# 2. RFM FEATURE ENGINEERING
# ============================================

print("\n" + "="*60)
print("RFM FEATURE ENGINEERING")
print("="*60)

# Convert date columns
orders_df['order_date'] = pd.to_datetime(orders_df['order_date'])

# Filter for completed orders
completed_orders = orders_df[orders_df['status'].isin(['Delivered', 'Shipped'])].copy()

# Calculate RFM metrics for each customer
reference_date = completed_orders['order_date'].max() + timedelta(days=1)

rfm_data = completed_orders.groupby('customer_id').agg({
    'order_date': lambda x: (reference_date - x.max()).days,  # Recency
    'order_id': 'count',  # Frequency
    'total_amount': 'sum'  # Monetary
}).reset_index()

rfm_data.columns = ['customer_id', 'recency_days', 'frequency', 'monetary']

print("\n=== RFM Raw Data ===")
print(rfm_data.head(10))

# Score RFM metrics (1-5 scale, where 5 is best)
rfm_data['recency_score'] = pd.qcut(rfm_data['recency_days'], 5, labels=[5, 4, 3, 2, 1], duplicates='drop')
rfm_data['frequency_score'] = pd.qcut(rfm_data['frequency'].rank(method='first'), 5, labels=[1, 2, 3, 4, 5], duplicates='drop')
rfm_data['monetary_score'] = pd.qcut(rfm_data['monetary'].rank(method='first'), 5, labels=[1, 2, 3, 4, 5], duplicates='drop')

# Convert scores to numeric
rfm_data['recency_score'] = rfm_data['recency_score'].astype(int)
rfm_data['frequency_score'] = rfm_data['frequency_score'].astype(int)
rfm_data['monetary_score'] = rfm_data['monetary_score'].astype(int)

# Calculate RFM score
rfm_data['rfm_score'] = rfm_data['recency_score'] * 100 + rfm_data['frequency_score'] * 10 + rfm_data['monetary_score']
rfm_data['rfm_total'] = rfm_data['recency_score'] + rfm_data['frequency_score'] + rfm_data['monetary_score']

# Segment customers based on RFM
def segment_customers(row):
    if row['recency_score'] >= 4 and row['frequency_score'] >= 4:
        return 'Champions'
    elif row['recency_score'] >= 3 and row['frequency_score'] >= 3:
        return 'Loyal Customers'
    elif row['recency_score'] >= 4 and row['frequency_score'] <= 2:
        return 'New Customers'
    elif row['recency_score'] >= 3 and row['frequency_score'] >= 2:
        return 'Potential Loyalists'
    elif row['recency_score'] <= 2 and row['frequency_score'] >= 4:
        return 'At Risk'
    elif row['recency_score'] <= 2 and row['frequency_score'] <= 2 and row['monetary_score'] >= 4:
        return "Can't Lose Them"
    elif row['recency_score'] >= 3:
        return 'About to Sleep'
    else:
        return 'Hibernating'

rfm_data['rfm_segment'] = rfm_data.apply(segment_customers, axis=1)

print("\n=== RFM Segments ===")
segment_counts = rfm_data['rfm_segment'].value_counts()
print(segment_counts)

# ============================================
# 3. CUSTOMER LIFETIME VALUE (CLV) FEATURES
# ============================================

print("\n" + "="*60)
print("CUSTOMER LIFETIME VALUE (CLV) FEATURES")
print("="*60)

# Calculate CLV using simple formula: Average Order Value × Purchase Frequency × Customer Lifespan
customer_stats = completed_orders.groupby('customer_id').agg({
    'order_id': 'count',
    'total_amount': ['sum', 'mean', 'std'],
    'order_date': ['min', 'max']
}).reset_index()
customer_stats.columns = ['customer_id', 'order_count', 'total_spent', 'avg_order_value',
                          'std_order_value', 'first_order_date', 'last_order_date']

# Calculate customer lifespan in days
customer_stats['customer_lifespan_days'] = (customer_stats['last_order_date'] -
                                            customer_stats['first_order_date']).dt.days + 1

# Calculate purchase frequency (orders per day)
customer_stats['purchase_frequency'] = customer_stats['order_count'] / customer_stats['customer_lifespan_days']

# Calculate CLV (simple model)
customer_stats['clv_simple'] = customer_stats['avg_order_value'] * customer_stats['purchase_frequency'] * 365

# Calculate CLV with retention adjustment (assuming 80% annual retention)
retention_rate = 0.8
customer_stats['clv_adjusted'] = customer_stats['avg_order_value'] * customer_stats['purchase_frequency'] * 365 / (1 - retention_rate)

print("\n=== CLV Statistics ===")
print(customer_stats[['customer_id', 'total_spent', 'avg_order_value', 'clv_simple', 'clv_adjusted']].describe())

# ============================================
# 4. BEHAVIORAL FEATURES
# ============================================

print("\n" + "="*60)
print("BEHAVIORAL FEATURES")
print("="*60)

# Days since last purchase
customer_stats['days_since_last_purchase'] = (datetime.now() - customer_stats['last_order_date']).dt.days

# Days since first purchase
customer_stats['days_since_first_purchase'] = (datetime.now() - customer_stats['first_order_date']).dt.days

# Average days between orders
customer_stats['avg_days_between_orders'] = customer_stats['customer_lifespan_days'] / (customer_stats['order_count'] - 1)
customer_stats['avg_days_between_orders'] = customer_stats['avg_days_between_orders'].fillna(0)

# Order value trend (last order vs average)
last_order_values = completed_orders.sort_values('order_date').groupby('customer_id').tail(1)[['customer_id', 'total_amount']]
last_order_values.columns = ['customer_id', 'last_order_value']
customer_stats = customer_stats.merge(last_order_values, on='customer_id', how='left')
customer_stats['last_order_vs_avg'] = customer_stats['last_order_value'] / customer_stats['avg_order_value']

# Discount usage
completed_orders['discount_used'] = completed_orders['discount_amount'] > 0
discount_usage = completed_orders.groupby('customer_id').agg({
    'discount_used': 'sum',
    'discount_amount': 'sum',
    'total_amount': 'sum'
}).reset_index()
discount_usage.columns = ['customer_id', 'discount_order_count', 'total_discount', 'total_amount']
discount_usage['discount_usage_rate'] = discount_usage['discount_order_count'] / completed_orders.groupby('customer_id').size()
discount_usage['discount_percentage'] = discount_usage['total_discount'] / discount_usage['total_amount']

customer_stats = customer_stats.merge(discount_usage[['customer_id', 'discount_usage_rate', 'discount_percentage']],
                                        on='customer_id', how='left')

print("\n=== Behavioral Features Sample ===")
print(customer_stats[['customer_id', 'days_since_last_purchase', 'avg_days_between_orders',
                       'discount_usage_rate', 'discount_percentage']].head(10))

# ============================================
# 5. PRODUCT PREFERENCE FEATURES
# ============================================

print("\n" + "="*60)
print("PRODUCT PREFERENCE FEATURES")
print("="*60)

# Merge order items with products
order_products = order_items_df.merge(products_df[['product_id', 'category_id', 'price']],
                                      on='product_id', how='left')
order_products = order_products.merge(orders_df[['order_id', 'customer_id', 'status']],
                                      on='order_id', how='left')
order_products = order_products[order_products['status'].isin(['Delivered', 'Shipped'])]

# Category preferences
category_purchases = order_products.groupby(['customer_id', 'category_id']).agg({
    'quantity': 'sum',
    'total_price': 'sum'
}).reset_index()

# Get top category for each customer
top_categories = category_purchases.sort_values(['customer_id', 'total_price'], ascending=[True, False])\
                                    .groupby('customer_id').head(1)
top_categories.columns = ['customer_id', 'preferred_category_id', 'preferred_category_quantity',
                          'preferred_category_spend']

# Category diversity (number of different categories purchased)
category_diversity = category_purchases.groupby('customer_id').size().reset_index(name='category_diversity')

customer_stats = customer_stats.merge(top_categories[['customer_id', 'preferred_category_id']],
                                        on='customer_id', how='left')
customer_stats = customer_stats.merge(category_diversity, on='customer_id', how='left')

# Average basket size (items per order)
basket_size = order_products.groupby(['customer_id', 'order_id']).size().reset_index(name='basket_size')
avg_basket_size = basket_size.groupby('customer_id')['basket_size'].mean().reset_index()
avg_basket_size.columns = ['customer_id', 'avg_basket_size']

customer_stats = customer_stats.merge(avg_basket_size, on='customer_id', how='left')

print("\n=== Product Preference Features Sample ===")
print(customer_stats[['customer_id', 'preferred_category_id', 'category_diversity',
                       'avg_basket_size']].head(10))

# ============================================
# 6. PRODUCT POPULARITY FEATURES
# ============================================

print("\n" + "="*60)
print("PRODUCT POPULARITY FEATURES")
print("="*60)

# Product popularity metrics
product_popularity = order_products.groupby('product_id').agg({
    'order_id': 'nunique',
    'customer_id': 'nunique',
    'quantity': 'sum',
    'total_price': 'sum'
}).reset_index()
product_popularity.columns = ['product_id', 'order_count', 'unique_customers',
                              'total_quantity', 'total_revenue']

# Calculate popularity score (weighted combination)
product_popularity['popularity_score'] = (
    product_popularity['order_count'] * 0.3 +
    product_popularity['unique_customers'] * 0.3 +
    product_popularity['total_quantity'] * 0.2 +
    product_popularity['total_revenue'] * 0.2
)

# Normalize popularity score
product_popularity['popularity_score_normalized'] = (
    (product_popularity['popularity_score'] - product_popularity['popularity_score'].min()) /
    (product_popularity['popularity_score'].max() - product_popularity['popularity_score'].min())
)

print("\n=== Top 10 Most Popular Products ===")
top_products = product_popularity.sort_values('popularity_score', ascending=False).head(10)
top_products = top_products.merge(products_df[['product_id', 'product_name']], on='product_id')
print(top_products[['product_id', 'product_name', 'order_count', 'total_revenue', 'popularity_score']])

# ============================================
# 7. COMBINE ALL FEATURES
# ============================================

print("\n" + "="*60)
print("COMBINING ALL FEATURES")
print("="*60)

# Merge RFM features
customer_features = customer_stats.merge(rfm_data[['customer_id', 'recency_days', 'recency_score',
                                                    'frequency_score', 'monetary_score', 'rfm_segment']],
                                         on='customer_id', how='left')

# Add customer demographic features
customer_features = customer_features.merge(customers_df[['customer_id', 'customer_segment', 'address_city',
                                                          'address_state', 'gender', 'marketing_consent']],
                                            on='customer_id', how='left')

# Encode categorical variables
segment_mapping = {'Bronze': 1, 'Silver': 2, 'Gold': 3, 'Platinum': 4}
customer_features['segment_encoded'] = customer_features['customer_segment'].map(segment_mapping)

gender_mapping = {'Male': 0, 'Female': 1, 'Other': 2}
customer_features['gender_encoded'] = customer_features['gender'].map(gender_mapping)

rfm_segment_mapping = {
    'Champions': 5,
    'Loyal Customers': 4,
    'New Customers': 3,
    'Potential Loyalists': 3,
    'At Risk': 2,
    "Can't Lose Them": 2,
    'About to Sleep': 1,
    'Hibernating': 1
}
customer_features['rfm_segment_encoded'] = customer_features['rfm_segment'].map(rfm_segment_mapping)

print("\n=== Final Feature Set ===")
print(f"Total features: {len(customer_features.columns)}")
print(f"Total customers: {len(customer_features)}")

# Display feature columns
feature_columns = [col for col in customer_features.columns if col not in ['customer_id', 'first_order_date',
                                                                            'last_order_date', 'last_order_value']]
print("\nFeature columns:")
for col in feature_columns:
    print(f"  - {col}")

# ============================================
# 8. FEATURE IMPORTANCE ANALYSIS
# ============================================

print("\n" + "="*60)
print("FEATURE IMPORTANCE ANALYSIS")
print("="*60)

# Select numeric features for correlation analysis
numeric_features = customer_features.select_dtypes(include=[np.number]).columns.tolist()
numeric_features = [col for col in numeric_features if col not in ['customer_id']]

# Calculate correlation with total_spent
correlations = customer_features[numeric_features].corr()['total_spent'].abs().sort_values(ascending=False)

print("\n=== Feature Correlation with Total Spent ===")
print(correlations.head(15))

# ============================================
# 9. EXPORT FEATURE ENGINEERED DATA
# ============================================

print("\n" + "="*60)
print("EXPORTING FEATURE ENGINEERED DATA")
print("="*60)

# Create output directory
os.makedirs('../data/processed', exist_ok=True)

# Export customer features
customer_features.to_csv('../data/processed/customer_features.csv', index=False)

# Export product popularity
product_popularity.to_csv('../data/processed/product_popularity.csv', index=False)

# Export RFM data
rfm_data.to_csv('../data/processed/rfm_data.csv', index=False)

print("\nFeature engineered data exported successfully!")
print("\nExported files:")
print("  - customer_features.csv")
print("  - product_popularity.csv")
print("  - rfm_data.csv")

print("\n" + "="*60)
print("FEATURE ENGINEERING COMPLETE!")
print("="*60)
