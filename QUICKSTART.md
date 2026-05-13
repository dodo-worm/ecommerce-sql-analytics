# E-Commerce Analytics - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Install Dependencies

```bash
cd ecommerce_analytics_project
pip install -r requirements.txt
```

### Step 2: Set Up Database

```bash
python scripts/setup_database.py
```

### Step 3: Run Analysis

```bash
# Exploratory Data Analysis
python notebooks/eda/01_exploratory_data_analysis.py

# Feature Engineering
python notebooks/feature_engineering/01_feature_engineering.py

# Machine Learning Models
python notebooks/ml/01_machine_learning_models.py
```

## 📁 Complete Project Structure

```
ecommerce_analytics_project/
│
├── data/                           # Data files
│   ├── raw/                        # Raw data (empty initially)
│   ├── processed/                  # Processed datasets (generated)
│   │   ├── customer_features.csv
│   │   ├── customer_stats.csv
│   │   ├── product_popularity.csv
│   │   ├── rfm_data.csv
│   │   ├── monthly_revenue.csv
│   │   ├── product_sales.csv
│   │   ├── state_stats.csv
│   │   └── category_performance.csv
│   └── sql/                        # SQLite database
│       └── ecommerce.db
│
├── sql/                            # SQL scripts
│   ├── schema/                     # Database schema
│   │   ├── 01_create_tables.sql    # Table definitions
│   │   └── 02_insert_sample_data.sql  # Sample data
│   ├── queries/                    # Business analytics queries
│   │   └── 01_business_analytics.sql  # 50+ queries
│   └── procedures/                 # Stored procedures
│
├── notebooks/                      # Analysis notebooks
│   ├── eda/                        # Exploratory Data Analysis
│   │   └── 01_exploratory_data_analysis.py
│   ├── feature_engineering/        # Feature Engineering
│   │   └── 01_feature_engineering.py
│   └── ml/                         # Machine Learning
│       └── 01_machine_learning_models.py
│
├── src/                            # Source code
│   ├── data_processing/            # Data processing utilities
│   ├── models/                     # ML model utilities
│   └── utils/                      # Helper functions
│
├── models/                         # Saved ML models (generated)
│   ├── churn_logistic_regression.pkl
│   ├── churn_random_forest.pkl
│   ├── churn_xgboost.pkl
│   ├── churn_scaler.pkl
│   ├── sales_random_forest.pkl
│   ├── sales_xgboost.pkl
│   ├── churn_features.pkl
│   └── sales_features.pkl
│
├── reports/                        # Generated reports
│   └── model_comparison.png
│
├── scripts/                        # Utility scripts
│   └── setup_database.py           # Database setup script
│
├── docs/                           # Documentation
│   ├── dashboard_guide.md          # Dashboard implementation guide
│   └── project_summary.md         # Complete project summary
│
├── dashboard/                      # Dashboard files
│
├── requirements.txt                # Python dependencies
├── README.md                       # Main documentation
└── QUICKSTART.md                   # This file
```

## 🎯 What Each File Does

### SQL Files

| File | Purpose |
|------|---------|
| `01_create_tables.sql` | Creates 7 database tables with proper schema |
| `02_insert_sample_data.sql` | Inserts 20 customers, 50 products, 60 orders |
| `01_business_analytics.sql` | 50+ queries for business analytics |

### Python Files

| File | Purpose |
|------|---------|
| `01_exploratory_data_analysis.py` | EDA with visualizations and statistics |
| `01_feature_engineering.py` | RFM, CLV, and behavioral features |
| `01_machine_learning_models.py` | Churn, recommendation, and sales models |
| `setup_database.py` | Automated database setup |

### Generated Files

| File | Purpose |
|------|---------|
| `ecommerce.db` | SQLite database with all data |
| `customer_features.csv` | Feature-engineered customer data |
| `*.pkl` | Trained ML models |
| `model_comparison.png` | Model performance visualization |

## 📊 Key Outputs

### After Running EDA

- Customer statistics and distributions
- Sales trend analysis
- Product performance metrics
- Regional analysis
- Correlation matrices

### After Running Feature Engineering

- RFM scores for each customer
- Customer Lifetime Value calculations
- Behavioral features
- Product popularity scores

### After Running ML Models

- Churn prediction models (3 models)
- Product recommendations
- Sales forecasting models (2 models)
- Model comparison visualizations

## 🔍 Quick Reference

### Database Schema

```
customers (1) ----< (N) orders
orders (1) ----< (N) order_items
products (1) ----< (N) order_items
categories (1) ----< (N) products
orders (1) ----< (N) payments
orders (1) ----< (N) reviews
```

### Key Metrics

| Metric | Value |
|--------|-------|
| Total Customers | 20 |
| Total Products | 50 |
| Total Orders | 60 |
| Total Categories | 16 |
| Total Reviews | 60 |

### ML Model Performance

| Model | Task | Metric | Score |
|-------|------|--------|-------|
| Random Forest | Churn Prediction | ROC-AUC | ~0.87 |
| XGBoost | Churn Prediction | ROC-AUC | ~0.86 |
| Random Forest | Sales Prediction | R² | ~0.92 |
| XGBoost | Sales Prediction | R² | ~0.90 |

## 🛠️ Troubleshooting

### Issue: Database not found

**Solution**: Run `python scripts/setup_database.py`

### Issue: Missing dependencies

**Solution**: Run `pip install -r requirements.txt`

### Issue: Import errors

**Solution**: Ensure you're in the project directory and Python path is correct

### Issue: Model not saving

**Solution**: Check that `models/` directory exists and has write permissions

## 📚 Next Steps

1. **Explore the Data**: Run the EDA notebook to understand the dataset
2. **Build Features**: Run feature engineering to create ML-ready features
3. **Train Models**: Run ML notebook to build predictive models
4. **Create Dashboard**: Follow the dashboard guide to build visualizations
5. **Customize**: Modify the code to add your own features and models

## 💡 Tips

- Use Jupyter notebooks for interactive exploration
- Save your work frequently
- Check the README for detailed documentation
- Review the project summary for interview preparation
- Experiment with different ML models and hyperparameters

## 🎓 Learning Path

1. **Week 1**: Database design and SQL queries
2. **Week 2**: EDA and feature engineering
3. **Week 3**: Machine learning models
4. **Week 4**: Dashboard and documentation

## 📞 Support

For detailed help, refer to:
- `README.md` - Complete project documentation
- `docs/project_summary.md` - Project overview and insights
- `docs/dashboard_guide.md` - Dashboard implementation

---

**Happy Analyzing! 🚀**
