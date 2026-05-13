# ============================================
# E-COMMERCE CUSTOMER ANALYTICS - MACHINE LEARNING MODELS
# ============================================
# This notebook builds ML models for churn prediction, product recommendation, and sales prediction

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split, cross_val_score, GridSearchCV
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier, RandomForestRegressor
from sklearn.metrics import (accuracy_score, precision_score, recall_score, f1_score,
                             roc_auc_score, confusion_matrix, classification_report,
                             mean_squared_error, mean_absolute_error, r2_score)
from xgboost import XGBClassifier, XGBRegressor
import warnings
warnings.filterwarnings('ignore')

# Set style
plt.style.use('seaborn-v0_8-darkgrid')
sns.set_palette("husl")

# ============================================
# 1. LOAD FEATURE ENGINEERED DATA
# ============================================

print("="*60)
print("LOADING FEATURE ENGINEERED DATA")
print("="*60)

# Load customer features
customer_features = pd.read_csv('../data/processed/customer_features.csv')

print(f"Customer features loaded: {customer_features.shape}")
print(f"\nColumns: {list(customer_features.columns)}")

# ============================================
# 2. CUSTOMER CHURN PREDICTION (TEMPORAL SPLIT)
# ============================================

print("\n" + "="*60)
print("CUSTOMER CHURN PREDICTION")
print("="*60)

import sqlite3

conn = sqlite3.connect('../data/sql/ecommerce.db')

orders_df = pd.read_sql_query("SELECT * FROM orders", conn)
orders_df['order_date'] = pd.to_datetime(orders_df['order_date'])

completed_orders = orders_df[
    orders_df['status'].isin(['Delivered', 'Shipped'])
].copy()

# -------------------------------
# Define temporal cutoff
# -------------------------------
cutoff_date = pd.Timestamp('2024-10-01')
prediction_window_days = 90
prediction_end = cutoff_date + pd.Timedelta(days=prediction_window_days)

print(f"Feature cutoff date: {cutoff_date}")
print(f"Prediction window ends: {prediction_end}")

# -------------------------------
# Historical data only
# -------------------------------
historical_orders = completed_orders[
    completed_orders['order_date'] < cutoff_date
]

future_orders = completed_orders[
    (completed_orders['order_date'] >= cutoff_date) &
    (completed_orders['order_date'] <= prediction_end)
]

# -------------------------------
# Build historical features
# -------------------------------
historical_features = historical_orders.groupby('customer_id').agg({
    'order_id': 'count',
    'total_amount': ['sum', 'mean', 'std'],
    'discount_amount': ['sum', 'mean'],
    'order_date': ['min', 'max']
}).reset_index()

historical_features.columns = [
    'customer_id',
    'order_count',
    'total_spent',
    'avg_order_value',
    'std_order_value',
    'total_discount',
    'avg_discount',
    'first_order_date',
    'last_order_date'
]

reference_date = cutoff_date

historical_features['customer_lifetime_days'] = (
    reference_date - historical_features['first_order_date']
).dt.days

historical_features['recency_days'] = (
    reference_date - historical_features['last_order_date']
).dt.days

historical_features['purchase_frequency'] = (
    historical_features['order_count'] /
    historical_features['customer_lifetime_days'].replace(0, 1)
)

historical_features['discount_ratio'] = (
    historical_features['total_discount'] /
    historical_features['total_spent'].replace(0, 1)
)

# -------------------------------
# Product diversity
# -------------------------------
order_items_df = pd.read_sql_query("SELECT * FROM order_items", conn)

historical_order_ids = historical_orders['order_id'].unique()

historical_items = order_items_df[
    order_items_df['order_id'].isin(historical_order_ids)
]

product_diversity = historical_items.groupby('customer_id').agg({
    'product_id': 'nunique',
    'quantity': 'mean'
}).reset_index()

product_diversity.columns = [
    'customer_id',
    'unique_products',
    'avg_basket_size'
]

historical_features = historical_features.merge(
    product_diversity,
    on='customer_id',
    how='left'
)

# -------------------------------
# Build churn target
# -------------------------------
future_customers = future_orders['customer_id'].unique()

historical_features['is_churned'] = ~historical_features[
    'customer_id'
].isin(future_customers)

historical_features['is_churned'] = historical_features[
    'is_churned'
].astype(int)

print("\nChurn distribution:")
print(historical_features['is_churned'].value_counts())

# -------------------------------
# Features
# -------------------------------
churn_features = [
    'order_count',
    'total_spent',
    'avg_order_value',
    'std_order_value',
    'total_discount',
    'avg_discount',
    'customer_lifetime_days',
    'recency_days',
    'purchase_frequency',
    'discount_ratio',
    'unique_products',
    'avg_basket_size'
]

X_churn = historical_features[churn_features].fillna(0)
y_churn = historical_features['is_churned']

# -------------------------------
# Split
# -------------------------------
X_train_churn, X_test_churn, y_train_churn, y_test_churn = train_test_split(
    X_churn,
    y_churn,
    test_size=0.3,
    random_state=42,
    stratify=y_churn
)

# -------------------------------
# Scale
# -------------------------------
scaler_churn = StandardScaler()

X_train_churn_scaled = scaler_churn.fit_transform(X_train_churn)
X_test_churn_scaled = scaler_churn.transform(X_test_churn)

# -------------------------------
# Models
# -------------------------------
log_reg = LogisticRegression(
    random_state=42,
    max_iter=1000,
    class_weight='balanced'
)

rf_clf = RandomForestClassifier(
    random_state=42,
    n_estimators=200,
    class_weight='balanced'
)

xgb_clf = XGBClassifier(
    random_state=42,
    n_estimators=200,
    eval_metric='logloss'
)

log_reg.fit(X_train_churn_scaled, y_train_churn)
rf_clf.fit(X_train_churn, y_train_churn)
xgb_clf.fit(X_train_churn, y_train_churn)

# ============================================
# 3. PRODUCT RECOMMENDATION (COLLABORATIVE FILTERING)
# ============================================

print("\n" + "="*60)
print("PRODUCT RECOMMENDATION")
print("="*60)

import sqlite3
from surprise import Dataset, Reader, SVD
from surprise.model_selection import train_test_split as surprise_train_test_split
from surprise.accuracy import rmse

conn = sqlite3.connect('../data/sql/ecommerce.db')

# -------------------------------
# Load purchase history
# -------------------------------
order_products = pd.read_sql_query("""
    SELECT
        o.customer_id,
        oi.product_id,
        SUM(oi.quantity) as purchase_count
    FROM order_items oi
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.status IN ('Delivered', 'Shipped')
    GROUP BY o.customer_id, oi.product_id
""", conn)

print(f"Purchase interactions: {order_products.shape}")

# -------------------------------
# Create surprise dataset
# -------------------------------
reader = Reader(rating_scale=(1, order_products['purchase_count'].max()))

data = Dataset.load_from_df(
    order_products[['customer_id', 'product_id', 'purchase_count']],
    reader
)

trainset, testset = surprise_train_test_split(
    data,
    test_size=0.2,
    random_state=42
)

# -------------------------------
# Train collaborative filtering model
# -------------------------------
svd_model = SVD(
    n_factors=100,
    n_epochs=20,
    random_state=42
)

svd_model.fit(trainset)

# Evaluate
predictions = svd_model.test(testset)

print("\nRecommendation Model Performance:")
rmse(predictions)

# -------------------------------
# Generate recommendations
# -------------------------------
products_df = pd.read_sql_query(
    "SELECT product_id, product_name FROM products",
    conn
)

sample_customer = order_products['customer_id'].iloc[0]

purchased_products = set(
    order_products[
        order_products['customer_id'] == sample_customer
    ]['product_id']
)

all_products = set(products_df['product_id'])

candidate_products = all_products - purchased_products

recommendations = []

for product_id in candidate_products:
    pred = svd_model.predict(
        uid=sample_customer,
        iid=product_id
    )

    recommendations.append(
        (product_id, pred.est)
    )

top_recommendations = sorted(
    recommendations,
    key=lambda x: x[1],
    reverse=True
)[:10]

top_recommendation_df = pd.DataFrame(
    top_recommendations,
    columns=['product_id', 'predicted_score']
)

top_recommendation_df = top_recommendation_df.merge(
    products_df,
    on='product_id',
    how='left'
)

print("\nTop 10 Recommendations:")
print(top_recommendation_df)

# -------------------------------
# Save recommendation model
# -------------------------------
import joblib
joblib.dump(
    svd_model,
    '../models/product_recommendation_svd.pkl'
)
# ============================================
# 4. SALES PREDICTION (TIME SERIES)
# ============================================

print("\n" + "="*60)
print("SALES PREDICTION")
print("="*60)

from sklearn.model_selection import TimeSeriesSplit
from xgboost import XGBRegressor

# Load monthly revenue data
monthly_revenue = pd.read_csv('../data/processed/monthly_revenue.csv')

# Clean date column
monthly_revenue['Year-Month'] = pd.to_datetime(
    monthly_revenue['Year-Month']
)

monthly_revenue = monthly_revenue.sort_values(
    'Year-Month'
).reset_index(drop=True)

# Feature engineering
monthly_revenue['year'] = monthly_revenue['Year-Month'].dt.year
monthly_revenue['month'] = monthly_revenue['Year-Month'].dt.month
monthly_revenue['quarter'] = monthly_revenue['Year-Month'].dt.quarter

# Lag features
monthly_revenue['revenue_lag1'] = monthly_revenue['Total Revenue'].shift(1)
monthly_revenue['revenue_lag2'] = monthly_revenue['Total Revenue'].shift(2)
monthly_revenue['revenue_lag3'] = monthly_revenue['Total Revenue'].shift(3)

monthly_revenue['orders_lag1'] = monthly_revenue['Total Orders'].shift(1)

# Rolling averages
monthly_revenue['revenue_ma3'] = (
    monthly_revenue['Total Revenue']
    .rolling(window=3)
    .mean()
)

monthly_revenue['orders_ma3'] = (
    monthly_revenue['Total Orders']
    .rolling(window=3)
    .mean()
)

monthly_revenue = monthly_revenue.dropna()

sales_features = [
    'year',
    'month',
    'quarter',
    'revenue_lag1',
    'revenue_lag2',
    'revenue_lag3',
    'orders_lag1',
    'revenue_ma3',
    'orders_ma3'
]

X_sales = monthly_revenue[sales_features]
y_sales = monthly_revenue['Total Revenue']

# -------------------------------
# Time Series Cross Validation
# -------------------------------
tscv = TimeSeriesSplit(n_splits=5)

sales_results = []

xgb_reg = XGBRegressor(
    random_state=42,
    n_estimators=200,
    max_depth=4,
    learning_rate=0.05
)

fold = 1

for train_idx, test_idx in tscv.split(X_sales):
    X_train, X_test = X_sales.iloc[train_idx], X_sales.iloc[test_idx]
    y_train, y_test = y_sales.iloc[train_idx], y_sales.iloc[test_idx]

    xgb_reg.fit(X_train, y_train)

    y_pred = xgb_reg.predict(X_test)

    mse = mean_squared_error(y_test, y_pred)
    mae = mean_absolute_error(y_test, y_pred)
    rmse = np.sqrt(mse)
    r2 = r2_score(y_test, y_pred)

    sales_results.append({
        'fold': fold,
        'mse': mse,
        'mae': mae,
        'rmse': rmse,
        'r2': r2
    })

    fold += 1

sales_results_df = pd.DataFrame(sales_results)

print("\nSales Prediction Cross Validation Results:")
print(sales_results_df)

print("\nAverage Performance:")
print(sales_results_df.mean())

# Feature importance
feature_importance_sales = pd.DataFrame({
    'feature': sales_features,
    'importance': xgb_reg.feature_importances_
}).sort_values('importance', ascending=False)

print("\nTop Sales Features:")
print(feature_importance_sales)

# ============================================
# 5. MODEL VISUALIZATION
# ============================================

print("\n" + "="*60)
print("MODEL VISUALIZATION")
print("="*60)

fig, axes = plt.subplots(2, 2, figsize=(16, 12))

# Churn model comparison
churn_results_melted = churn_results_df.melt(id_vars=['model'], var_name='metric', value_name='value')
sns.barplot(data=churn_results_melted, x='metric', y='value', hue='model', ax=axes[0, 0])
axes[0, 0].set_title('Churn Model Comparison', fontsize=14, fontweight='bold')
axes[0, 0].set_xlabel('Metric')
axes[0, 0].set_ylabel('Score')
axes[0, 0].legend(title='Model')
axes[0, 0].tick_params(axis='x', rotation=45)

# Feature importance for churn
top_features = feature_importance_churn.head(10)
sns.barplot(data=top_features, x='importance', y='feature', ax=axes[0, 1])
axes[0, 1].set_title('Top 10 Features - Churn Prediction', fontsize=14, fontweight='bold')
axes[0, 1].set_xlabel('Importance')
axes[0, 1].set_ylabel('Feature')

# Sales model comparison
sales_results_melted = sales_results_df.melt(id_vars=['model'], var_name='metric', value_name='value')
sns.barplot(data=sales_results_melted, x='metric', y='value', hue='model', ax=axes[1, 0])
axes[1, 0].set_title('Sales Model Comparison', fontsize=14, fontweight='bold')
axes[1, 0].set_xlabel('Metric')
axes[1, 0].set_ylabel('Value')
axes[1, 0].legend(title='Model')
axes[1, 0].tick_params(axis='x', rotation=45)

# Feature importance for sales
sns.barplot(data=feature_importance_sales, x='importance', y='feature', ax=axes[1, 1])
axes[1, 1].set_title('Feature Importance - Sales Prediction', fontsize=14, fontweight='bold')
axes[1, 1].set_xlabel('Importance')
axes[1, 1].set_ylabel('Feature')

plt.tight_layout()
plt.savefig('../reports/model_comparison.png', dpi=300, bbox_inches='tight')
plt.show()

# ============================================
# 6. SAVE MODELS
# ============================================

print("\n" + "="*60)
print("SAVING MODELS")
print("="*60)

import joblib
import os
os.makedirs('../models', exist_ok=True)

# Save churn models
joblib.dump(log_reg, '../models/churn_logistic_regression.pkl')
joblib.dump(rf_clf, '../models/churn_random_forest.pkl')
joblib.dump(xgb_clf, '../models/churn_xgboost.pkl')
joblib.dump(scaler_churn, '../models/churn_scaler.pkl')

# Save sales models
joblib.dump(rf_reg, '../models/sales_random_forest.pkl')
joblib.dump(xgb_reg, '../models/sales_xgboost.pkl')

# Save feature lists
joblib.dump(churn_features, '../models/churn_features.pkl')
joblib.dump(sales_features, '../models/sales_features.pkl')

print("Models saved successfully!")
print("\nSaved models:")
print("  - churn_logistic_regression.pkl")
print("  - churn_random_forest.pkl")
print("  - churn_xgboost.pkl")
print("  - churn_scaler.pkl")
print("  - sales_random_forest.pkl")
print("  - sales_xgboost.pkl")
print("  - churn_features.pkl")
print("  - sales_features.pkl")

# ============================================
# 7. SUMMARY
# ============================================

print("\n" + "="*60)
print("MACHINE LEARNING SUMMARY")
print("="*60)

print("\n📊 CHURN PREDICTION")
print(f"  - Best Model: {churn_results_df.loc[churn_results_df['roc_auc'].idxmax(), 'model']}")
print(f"  - Best ROC-AUC: {churn_results_df['roc_auc'].max():.4f}")
print(f"  - Best F1-Score: {churn_results_df['f1'].max():.4f}")

print("\n🛒 PRODUCT RECOMMENDATION")
print(f"  - Top Recommended Product: {top_recommended.iloc[0]['product_name']}")
print(f"  - Recommendation Score: {top_recommended.iloc[0]['recommendation_score']:.4f}")

print("\n💰 SALES PREDICTION")
print(f"  - Best Model: {sales_results_df.loc[sales_results_df['r2'].idxmax(), 'model']}")
print(f"  - Best R² Score: {sales_results_df['r2'].max():.4f}")
print(f"  - Best RMSE: ${sales_results_df['rmse'].min():.2f}")

print("\n" + "="*60)
print("MACHINE LEARNING COMPLETE!")
print("="*60)
