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
# 2. CUSTOMER CHURN PREDICTION
# ============================================

print("\n" + "="*60)
print("CUSTOMER CHURN PREDICTION")
print("="*60)

# Define churn: customers who haven't purchased in the last 90 days
churn_threshold_days = 90
customer_features['is_churned'] = (customer_features['days_since_last_purchase'] > churn_threshold_days).astype(int)

print(f"\nChurn threshold: {churn_threshold_days} days")
print(f"Churned customers: {customer_features['is_churned'].sum()}")
print(f"Active customers: {(customer_features['is_churned'] == 0).sum()}")
print(f"Churn rate: {customer_features['is_churned'].mean():.2%}")

# Select features for churn prediction
churn_features = [
    'order_count', 'total_spent', 'avg_order_value', 'std_order_value',
    'days_since_last_purchase', 'days_since_first_purchase',
    'avg_days_between_orders', 'last_order_vs_avg',
    'discount_usage_rate', 'discount_percentage',
    'category_diversity', 'avg_basket_size',
    'recency_score', 'frequency_score', 'monetary_score',
    'segment_encoded', 'rfm_segment_encoded'
]

# Prepare data
X_churn = customer_features[churn_features].copy()
y_churn = customer_features['is_churned']

# Handle missing values
X_churn = X_churn.fillna(0)

# Split data
X_train_churn, X_test_churn, y_train_churn, y_test_churn = train_test_split(
    X_churn, y_churn, test_size=0.3, random_state=42, stratify=y_churn
)

# Scale features
scaler_churn = StandardScaler()
X_train_churn_scaled = scaler_churn.fit_transform(X_train_churn)
X_test_churn_scaled = scaler_churn.transform(X_test_churn)

print(f"\nTraining set: {X_train_churn_scaled.shape}")
print(f"Test set: {X_test_churn_scaled.shape}")

# Train multiple models
print("\n--- Training Churn Prediction Models ---")

# Model 1: Logistic Regression
log_reg = LogisticRegression(random_state=42, max_iter=1000)
log_reg.fit(X_train_churn_scaled, y_train_churn)

# Model 2: Random Forest
rf_clf = RandomForestClassifier(random_state=42, n_estimators=100)
rf_clf.fit(X_train_churn, y_train_churn)

# Model 3: XGBoost
xgb_clf = XGBClassifier(random_state=42, n_estimators=100, use_label_encoder=False, eval_metric='logloss')
xgb_clf.fit(X_train_churn, y_train_churn)

# Evaluate models
def evaluate_churn_model(model, X_test, y_test, model_name, scaled=False):
    """Evaluate churn prediction model."""
    if scaled:
        y_pred = model.predict(X_test)
        y_pred_proba = model.predict_proba(X_test)[:, 1]
    else:
        y_pred = model.predict(X_test)
        y_pred_proba = model.predict_proba(X_test)[:, 1]

    accuracy = accuracy_score(y_test, y_pred)
    precision = precision_score(y_test, y_pred, average='binary')
    recall = recall_score(y_test, y_pred, average='binary')
    f1 = f1_score(y_test, y_pred, average='binary')
    roc_auc = roc_auc_score(y_test, y_pred_proba)

    print(f"\n{model_name} Results:")
    print(f"  Accuracy:  {accuracy:.4f}")
    print(f"  Precision: {precision:.4f}")
    print(f"  Recall:    {recall:.4f}")
    print(f"  F1-Score:  {f1:.4f}")
    print(f"  ROC-AUC:   {roc_auc:.4f}")

    return {
        'model': model_name,
        'accuracy': accuracy,
        'precision': precision,
        'recall': recall,
        'f1': f1,
        'roc_auc': roc_auc
    }

churn_results = []
churn_results.append(evaluate_churn_model(log_reg, X_test_churn_scaled, y_test_churn, "Logistic Regression", scaled=True))
churn_results.append(evaluate_churn_model(rf_clf, X_test_churn, y_test_churn, "Random Forest"))
churn_results.append(evaluate_churn_model(xgb_clf, X_test_churn, y_test_churn, "XGBoost"))

# Compare models
churn_results_df = pd.DataFrame(churn_results)
print("\n" + "="*60)
print("CHURN MODEL COMPARISON")
print("="*60)
print(churn_results_df)

# Feature importance for best model (Random Forest)
feature_importance_churn = pd.DataFrame({
    'feature': churn_features,
    'importance': rf_clf.feature_importances_
}).sort_values('importance', ascending=False)

print("\n--- Top 10 Important Features for Churn Prediction ---")
print(feature_importance_churn.head(10))

# ============================================
# 3. PRODUCT RECOMMENDATION
# ============================================

print("\n" + "="*60)
print("PRODUCT RECOMMENDATION")
print("="*60)

# Load product data
product_popularity = pd.read_csv('../data/processed/product_popularity.csv')
products_df = pd.read_sql_query("SELECT * FROM products", sqlite3.connect('../data/sql/ecommerce.db'))

# Create product recommendation features
product_features = product_popularity.merge(
    products_df[['product_id', 'category_id', 'price', 'rating_avg', 'review_count']],
    on='product_id'
)

# Create recommendation score
product_features['recommendation_score'] = (
    product_features['popularity_score_normalized'] * 0.4 +
    (product_features['rating_avg'] / 5) * 0.3 +
    (product_features['review_count'] / product_features['review_count'].max()) * 0.2 +
    (1 - (product_features['price'] - product_features['price'].min()) /
     (product_features['price'].max() - product_features['price'].min())) * 0.1
)

print("\n--- Top 10 Recommended Products ---")
top_recommended = product_features.sort_values('recommendation_score', ascending=False).head(10)
print(top_recommended[['product_id', 'product_name', 'recommendation_score', 'rating_avg', 'price']])

# Collaborative filtering based on purchase patterns
print("\n--- Building Collaborative Filtering Model ---")

# Create user-item matrix
order_products = pd.read_sql_query("""
    SELECT oi.order_id, oi.customer_id, oi.product_id, oi.quantity, oi.total_price
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.status IN ('Delivered', 'Shipped')
""", sqlite3.connect('../data/sql/ecommerce.db'))

# Create purchase frequency matrix
user_item_matrix = order_products.groupby(['customer_id', 'product_id']).size().reset_index(name='purchase_count')

# Simple recommendation: products frequently bought together
print("\n--- Frequently Bought Together (Top 5 Pairs) ---")

# Find product pairs bought together
from collections import defaultdict
product_pairs = defaultdict(int)

for customer_id in user_item_matrix['customer_id'].unique():
    products = user_item_matrix[user_item_matrix['customer_id'] == customer_id]['product_id'].tolist()
    products.sort()
    for i in range(len(products)):
        for j in range(i+1, len(products)):
            product_pairs[(products[i], products[j])] += 1

# Get top pairs
top_pairs = sorted(product_pairs.items(), key=lambda x: x[1], reverse=True)[:5]

for (prod1, prod2), count in top_pairs:
    name1 = products_df[products_df['product_id'] == prod1]['product_name'].values[0]
    name2 = products_df[products_df['product_id'] == prod2]['product_name'].values[0]
    print(f"  {name1} + {name2}: {count} times")

# ============================================
# 4. SALES PREDICTION
# ============================================

print("\n" + "="*60)
print("SALES PREDICTION")
print("="*60)

# Load monthly revenue data
monthly_revenue = pd.read_csv('../data/processed/monthly_revenue.csv')

# Prepare features for sales prediction
monthly_revenue['year'] = monthly_revenue['Year-Month'].str[:4].astype(int)
monthly_revenue['month'] = monthly_revenue['Year-Month'].str[5:].astype(int)

# Create lag features
monthly_revenue['revenue_lag1'] = monthly_revenue['Total Revenue'].shift(1)
monthly_revenue['revenue_lag2'] = monthly_revenue['Total Revenue'].shift(2)
monthly_revenue['orders_lag1'] = monthly_revenue['Total Orders'].shift(1)

# Create moving average features
monthly_revenue['revenue_ma3'] = monthly_revenue['Total Revenue'].rolling(window=3).mean()
monthly_revenue['orders_ma3'] = monthly_revenue['Total Orders'].rolling(window=3).mean()

# Drop NaN values
monthly_revenue_clean = monthly_revenue.dropna()

# Select features
sales_features = ['year', 'month', 'revenue_lag1', 'revenue_lag2', 'orders_lag1',
                  'revenue_ma3', 'orders_ma3']

X_sales = monthly_revenue_clean[sales_features]
y_sales = monthly_revenue_clean['Total Revenue']

# Split data (use last 3 months for testing)
X_train_sales, X_test_sales, y_train_sales, y_test_sales = train_test_split(
    X_sales, y_sales, test_size=0.25, shuffle=False
)

print(f"\nTraining set: {X_train_sales.shape}")
print(f"Test set: {X_test_sales.shape}")

# Train regression models
print("\n--- Training Sales Prediction Models ---")

# Model 1: Random Forest Regressor
rf_reg = RandomForestRegressor(random_state=42, n_estimators=100)
rf_reg.fit(X_train_sales, y_train_sales)

# Model 2: XGBoost Regressor
xgb_reg = XGBRegressor(random_state=42, n_estimators=100)
xgb_reg.fit(X_train_sales, y_train_sales)

# Evaluate regression models
def evaluate_regression_model(model, X_test, y_test, model_name):
    """Evaluate regression model."""
    y_pred = model.predict(X_test)

    mse = mean_squared_error(y_test, y_pred)
    mae = mean_absolute_error(y_test, y_pred)
    rmse = np.sqrt(mse)
    r2 = r2_score(y_test, y_pred)

    print(f"\n{model_name} Results:")
    print(f"  MSE:  {mse:.2f}")
    print(f"  MAE:  {mae:.2f}")
    print(f"  RMSE: {rmse:.2f}")
    print(f"  R²:   {r2:.4f}")

    return {
        'model': model_name,
        'mse': mse,
        'mae': mae,
        'rmse': rmse,
        'r2': r2
    }

sales_results = []
sales_results.append(evaluate_regression_model(rf_reg, X_test_sales, y_test_sales, "Random Forest"))
sales_results.append(evaluate_regression_model(xgb_reg, X_test_sales, y_test_sales, "XGBoost"))

# Compare models
sales_results_df = pd.DataFrame(sales_results)
print("\n" + "="*60)
print("SALES MODEL COMPARISON")
print("="*60)
print(sales_results_df)

# Feature importance for sales prediction
feature_importance_sales = pd.DataFrame({
    'feature': sales_features,
    'importance': rf_reg.feature_importances_
}).sort_values('importance', ascending=False)

print("\n--- Feature Importance for Sales Prediction ---")
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
