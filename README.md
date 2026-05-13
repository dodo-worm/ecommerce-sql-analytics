# E-Commerce Customer Analytics & Machine Learning Platform

## Overview

This project is an end-to-end data analytics and machine learning platform for e-commerce customer intelligence.

It combines:

- Advanced SQL analytics
- Exploratory Data Analysis (EDA)
- Feature engineering
- Customer churn prediction
- Product recommendation system
- Sales forecasting
- Dashboard reporting

The goal is to simulate a real-world e-commerce analytics environment where business data is transformed into actionable machine learning insights.

---

## Business Problems Solved

### 1. Customer Churn Prediction
Predict customers likely to stop purchasing using historical transaction behavior.

Techniques:
- Temporal feature engineering
- Logistic Regression
- Random Forest
- XGBoost

---

### 2. Product Recommendation System
Recommend products using collaborative filtering based on customer purchase history.

Techniques:
- Matrix Factorization
- SVD Recommendation Engine
- Collaborative Filtering

---

### 3. Sales Forecasting
Forecast future sales revenue using time-series machine learning.

Techniques:
- Lag features
- Rolling averages
- TimeSeriesSplit validation
- XGBoost Regression

---

## Tech Stack

### Database & SQL
- SQLite
- SQL
- Joins
- CTEs
- Window Functions
- Business Analytics Queries

### Python & Analytics
- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn

## Feature Engineering

The project includes business-focused feature engineering for predictive analytics.

### Customer Features
- Recency (days since last purchase before cutoff date)
- Frequency (historical order count)
- Monetary value (historical spend)
- Average order value
- Purchase frequency
- Discount usage ratio
- Customer lifetime duration
- Average basket size
- Unique products purchased

### Product Features
- Customer-product interaction matrix
- Purchase count per customer-product pair
- Product recommendation candidate generation

### Time-Series Features
- Revenue lag (1, 2, 3 months)
- Order lag features
- 3-month rolling revenue average
- 3-month rolling order average
- Seasonal time features (month, quarter)

---

## Machine Learning Models

### Customer Churn Prediction
Models:
- Logistic Regression
- Random Forest
- XGBoost

Evaluation Metrics:
- Accuracy
- Precision
- Recall
- F1 Score
- ROC-AUC

---

### Product Recommendation System
Model:
- SVD Collaborative Filtering (Matrix Factorization)

Evaluation:
- RMSE

---

### Sales Forecasting
Model:
- XGBoost Regressor

Validation:
- TimeSeriesSplit cross-validation

Evaluation:
- RMSE
- MAE
- R²

---

## SQL Analytics

Advanced SQL analysis includes:
- Top customers by revenue
- Monthly revenue trends
- Product sales performance
- Repeat customer analysis
- Customer segmentation
- Regional sales insights
- Retention analytics

### Machine Learning
- Scikit-learn
- XGBoost
- Surprise
- Time Series Forecasting

### Dashboard
- Power BI / Tableau

---

## Project Structure

```bash
ecommerce-sql-analytics/
│
├── dashboard/
├── docs/
├── notebooks/
│   ├── eda/
│   ├── feature_engineering/
│   └── ml/
│
├── reports/
├── scripts/
├── sql/
│   ├── schema/
│   └── queries/
│
├── src/
├── models/
├── requirements.txt
└── README.md


