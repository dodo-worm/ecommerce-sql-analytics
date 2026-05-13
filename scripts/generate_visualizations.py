#!/usr/bin/env python3
"""
Generate visualization images for the E-Commerce Analytics project.
This script creates sample charts and saves them to the reports folder.
"""

import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np
from pathlib import Path
import os

# Set style
plt.style.use('seaborn-v0_8-darkgrid')
sns.set_palette("husl")

# Create reports directory
reports_dir = Path(__file__).parent.parent / 'reports'
reports_dir.mkdir(parents=True, exist_ok=True)

print("Generating visualization images...")

# ============================================
# 1. Revenue Trend Chart
# ============================================
fig, ax = plt.subplots(figsize=(12, 6))

months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
revenue = [2711, 4537, 4537, 5538, 4537, 5538,
            4537, 4537, 4537, 4537, 4537, 5538]

ax.plot(months, revenue, marker='o', linewidth=2.5, markersize=8,
        color='#2563EB', label='Revenue')
ax.fill_between(months, revenue, alpha=0.3, color='#2563EB')

ax.set_title('Monthly Revenue Trend (2024)', fontsize=16, fontweight='bold')
ax.set_xlabel('Month', fontsize=12)
ax.set_ylabel('Revenue ($)', fontsize=12)
ax.legend(loc='upper left')
ax.grid(True, alpha=0.3)

# Add value labels
for i, v in enumerate(revenue):
    ax.text(i, v + 100, f'${v:,}', ha='center', va='bottom', fontweight='bold')

plt.tight_layout()
plt.savefig(reports_dir / 'revenue_trend.png', dpi=300, bbox_inches='tight')
plt.close()
print("[OK] Generated: revenue_trend.png")

# ============================================
# 2. Customer Segmentation Donut Chart
# ============================================
fig, ax = plt.subplots(figsize=(10, 8))

segments = ['Champions', 'Loyal Customers', 'New Customers', 'At Risk', 'Hibernating']
counts = [4, 6, 4, 3, 3]
colors = ['#F59E0B', '#3B82F6', '#10B981', '#F97316', '#EF4444']

wedges, texts, autotexts = ax.pie(counts, labels=segments, autopct='%1.1f%%',
                                    colors=colors, startangle=90,
                                    wedgeprops=dict(width=0.5, edgecolor='white'))

# Enhance text
for autotext in autotexts:
    autotext.set_color('white')
    autotext.set_fontweight('bold')
    autotext.set_fontsize(12)

for text in texts:
    text.set_fontweight('bold')
    text.set_fontsize(11)

ax.set_title('Customer Segmentation Distribution', fontsize=16, fontweight='bold', pad=20)
plt.tight_layout()
plt.savefig(reports_dir / 'customer_segmentation.png', dpi=300, bbox_inches='tight')
plt.close()
print("[OK] Generated: customer_segmentation.png")

# ============================================
# 3. Top Products Bar Chart
# ============================================
fig, ax = plt.subplots(figsize=(12, 8))

products = ['Peloton Bike+', 'MacBook Pro 16"', 'ASUS ROG Zephyrus',
            'iPhone 15 Pro Max', 'Lenovo ThinkPad X1', 'Dell XPS 15',
            'NordicTrack Treadmill', 'Samsung Galaxy S24 Ultra']
revenue = [2495, 2249, 2185, 1194, 1788, 1886, 1597, 1293]

bars = ax.barh(products, revenue, color='#10B981', alpha=0.8, edgecolor='black', linewidth=1.5)

ax.set_title('Top 8 Products by Revenue', fontsize=16, fontweight='bold')
ax.set_xlabel('Revenue ($)', fontsize=12)
ax.invert_yaxis()

# Add value labels
for bar in bars:
    width = bar.get_width()
    ax.text(width + 50, bar.get_y() + bar.get_height()/2,
            f'${width:,.0f}', ha='left', va='center', fontweight='bold')

plt.tight_layout()
plt.savefig(reports_dir / 'top_products.png', dpi=300, bbox_inches='tight')
plt.close()
print("[OK] Generated: top_products.png")

# ============================================
# 4. Category Performance Treemap-style Bar Chart
# ============================================
fig, ax = plt.subplots(figsize=(12, 6))

categories = ['Electronics', 'Home & Garden', 'Sports & Outdoors',
              'Clothing', 'Books']
revenue = [28450, 8920, 6540, 5230, 3707]
colors = ['#3B82F6', '#10B981', '#F59E0B', '#8B5CF6', '#EC4899']

bars = ax.bar(categories, revenue, color=colors, alpha=0.8,
              edgecolor='black', linewidth=1.5)

ax.set_title('Revenue by Category', fontsize=16, fontweight='bold')
ax.set_xlabel('Category', fontsize=12)
ax.set_ylabel('Revenue ($)', fontsize=12)
ax.tick_params(axis='x', rotation=45)

# Add value labels
for bar in bars:
    height = bar.get_height()
    ax.text(bar.get_x() + bar.get_width()/2., height,
            f'${height:,.0f}', ha='center', va='bottom', fontweight='bold')

plt.tight_layout()
plt.savefig(reports_dir / 'category_performance.png', dpi=300, bbox_inches='tight')
plt.close()
print("[OK] Generated: category_performance.png")

# ============================================
# 5. Regional Sales Map-style Bar Chart
# ============================================
fig, ax = plt.subplots(figsize=(12, 6))

states = ['California', 'Texas', 'New York', 'Washington',
          'Illinois', 'Pennsylvania', 'Colorado', 'Massachusetts']
revenue = [18450, 12890, 8230, 5886, 4555, 4127, 3554, 3554]

bars = ax.bar(states, revenue, color='#6366F1', alpha=0.8,
              edgecolor='black', linewidth=1.5)

ax.set_title('Sales by State', fontsize=16, fontweight='bold')
ax.set_xlabel('State', fontsize=12)
ax.set_ylabel('Revenue ($)', fontsize=12)
ax.tick_params(axis='x', rotation=45)

# Add value labels
for bar in bars:
    height = bar.get_height()
    ax.text(bar.get_x() + bar.get_width()/2., height,
            f'${height:,.0f}', ha='center', va='bottom', fontweight='bold')

plt.tight_layout()
plt.savefig(reports_dir / 'regional_sales.png', dpi=300, bbox_inches='tight')
plt.close()
print("[OK] Generated: regional_sales.png")

# ============================================
# 6. Model Comparison Chart
# ============================================
fig, axes = plt.subplots(1, 2, figsize=(14, 6))

# Churn Model Comparison
models = ['Logistic\nRegression', 'Random\nForest', 'XGBoost']
accuracy = [0.82, 0.87, 0.85]
precision = [0.80, 0.86, 0.84]
recall = [0.78, 0.86, 0.83]
f1 = [0.79, 0.86, 0.83]
roc_auc = [0.84, 0.87, 0.86]

x = np.arange(len(models))
width = 0.15

axes[0].bar(x - 2*width, accuracy, width, label='Accuracy', color='#3B82F6')
axes[0].bar(x - width, precision, width, label='Precision', color='#10B981')
axes[0].bar(x, recall, width, label='Recall', color='#F59E0B')
axes[0].bar(x + width, f1, width, label='F1-Score', color='#8B5CF6')
axes[0].bar(x + 2*width, roc_auc, width, label='ROC-AUC', color='#EC4899')

axes[0].set_title('Churn Prediction Model Comparison', fontsize=14, fontweight='bold')
axes[0].set_ylabel('Score', fontsize=12)
axes[0].set_xticks(x)
axes[0].set_xticklabels(models)
axes[0].legend(loc='lower right')
axes[0].set_ylim([0.7, 1.0])
axes[0].grid(True, alpha=0.3, axis='y')

# Sales Model Comparison
sales_models = ['Random Forest', 'XGBoost']
r2 = [0.92, 0.90]
rmse = [245, 280]

x2 = np.arange(len(sales_models))
width2 = 0.35

axes[1].bar(x2 - width2/2, r2, width2, label='R² Score', color='#10B981')
axes[1].bar(x2 + width2/2, [v/1000 for v in rmse], width2, label='RMSE (×1000)', color='#F59E0B')

axes[1].set_title('Sales Prediction Model Comparison', fontsize=14, fontweight='bold')
axes[1].set_ylabel('Score', fontsize=12)
axes[1].set_xticks(x2)
axes[1].set_xticklabels(sales_models)
axes[1].legend(loc='lower right')
axes[1].set_ylim([0, 1.0])
axes[1].grid(True, alpha=0.3, axis='y')

plt.tight_layout()
plt.savefig(reports_dir / 'model_comparison.png', dpi=300, bbox_inches='tight')
plt.close()
print("[OK] Generated: model_comparison.png")

# ============================================
# 7. RFM Analysis Heatmap
# ============================================
fig, ax = plt.subplots(figsize=(10, 8))

# Create sample RFM data
rfm_data = np.array([
    [5, 5, 5, 15],  # Champions
    [4, 4, 4, 12],  # Loyal
    [5, 2, 3, 10],  # New
    [2, 4, 4, 10],  # At Risk
    [1, 1, 5, 7],   # Can't Lose
    [3, 2, 2, 7],   # About to Sleep
    [1, 1, 1, 3]    # Hibernating
])

rfm_labels = ['Champions', 'Loyal Customers', 'New Customers',
              'At Risk', "Can't Lose", 'About to Sleep', 'Hibernating']
score_labels = ['Recency', 'Frequency', 'Monetary', 'Total']

sns.heatmap(rfm_data, annot=True, fmt='d', cmap='RdYlGn',
            xticklabels=score_labels, yticklabels=rfm_labels,
            cbar_kws={'label': 'Score'}, linewidths=1, linecolor='white')

ax.set_title('RFM Segment Analysis', fontsize=16, fontweight='bold')
plt.tight_layout()
plt.savefig(reports_dir / 'rfm_analysis.png', dpi=300, bbox_inches='tight')
plt.close()
print("[OK] Generated: rfm_analysis.png")

# ============================================
# 8. Order Distribution by Day of Week
# ============================================
fig, ax = plt.subplots(figsize=(12, 6))

days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday',
        'Friday', 'Saturday', 'Sunday']
orders = [8, 9, 8, 9, 10, 8, 8]

bars = ax.bar(days, orders, color='#8B5CF6', alpha=0.8,
              edgecolor='black', linewidth=1.5)

ax.set_title('Orders by Day of Week', fontsize=16, fontweight='bold')
ax.set_xlabel('Day of Week', fontsize=12)
ax.set_ylabel('Number of Orders', fontsize=12)
ax.tick_params(axis='x', rotation=45)

# Add value labels
for bar in bars:
    height = bar.get_height()
    ax.text(bar.get_x() + bar.get_width()/2., height,
            f'{int(height)}', ha='center', va='bottom', fontweight='bold')

plt.tight_layout()
plt.savefig(reports_dir / 'orders_by_day.png', dpi=300, bbox_inches='tight')
plt.close()
print("[OK] Generated: orders_by_day.png")

# ============================================
# 9. Payment Method Distribution
# ============================================
fig, ax = plt.subplots(figsize=(10, 8))

methods = ['Credit Card', 'PayPal', 'Debit Card']
counts = [40, 12, 8]
colors = ['#3B82F6', '#10B981', '#F59E0B']

wedges, texts, autotexts = ax.pie(counts, labels=methods, autopct='%1.1f%%',
                                    colors=colors, startangle=90,
                                    wedgeprops=dict(edgecolor='white', linewidth=2))

for autotext in autotexts:
    autotext.set_color('white')
    autotext.set_fontweight('bold')
    autotext.set_fontsize(14)

for text in texts:
    text.set_fontweight('bold')
    text.set_fontsize(12)

ax.set_title('Payment Method Distribution', fontsize=16, fontweight='bold', pad=20)
plt.tight_layout()
plt.savefig(reports_dir / 'payment_methods.png', dpi=300, bbox_inches='tight')
plt.close()
print("[OK] Generated: payment_methods.png")

# ============================================
# 10. Customer Retention Rate
# ============================================
fig, ax = plt.subplots(figsize=(12, 6))

months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
retention = [100, 95, 90, 88, 85, 83, 80, 78, 75, 73, 70, 68]

ax.plot(months, retention, marker='o', linewidth=2.5, markersize=8,
        color='#10B981', label='Retention Rate')
ax.fill_between(months, retention, alpha=0.3, color='#10B981')

ax.set_title('Customer Retention Rate (2024)', fontsize=16, fontweight='bold')
ax.set_xlabel('Month', fontsize=12)
ax.set_ylabel('Retention Rate (%)', fontsize=12)
ax.set_ylim([60, 105])
ax.legend(loc='upper right')
ax.grid(True, alpha=0.3)

# Add value labels
for i, v in enumerate(retention):
    ax.text(i, v + 2, f'{v}%', ha='center', va='bottom', fontweight='bold')

plt.tight_layout()
plt.savefig(reports_dir / 'customer_retention.png', dpi=300, bbox_inches='tight')
plt.close()
print("[OK] Generated: customer_retention.png")

print("\n" + "="*60)
print("VISUALIZATION GENERATION COMPLETE!")
print("="*60)
print(f"\nAll images saved to: {reports_dir}")
print("\nGenerated files:")
for file in reports_dir.glob('*.png'):
    print(f"  - {file.name}")
