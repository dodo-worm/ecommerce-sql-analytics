# E-Commerce Analytics Dashboard - Power BI Template

## Dashboard Overview

This document provides a complete template for creating an E-Commerce Analytics Dashboard in Power BI.

## 📊 Dashboard Pages

### Page 1: Executive Summary

**Visuals**:
1. **KPI Cards** (Top Row)
   - Total Revenue (Card)
   - Total Orders (Card)
   - Active Customers (Card)
   - Average Order Value (Card)
   - Churn Rate (Card)
   - Conversion Rate (Card)

2. **Revenue Trend** (Large Line Chart)
   - X-axis: Month
   - Y-axis: Revenue
   - Legend: Year

3. **Order Volume** (Bar Chart)
   - X-axis: Month
   - Y-axis: Order Count
   - Color: Status

4. **Customer Growth** (Area Chart)
   - X-axis: Month
   - Y-axis: Cumulative Customers

### Page 2: Customer Analytics

**Visuals**:
1. **Customer Segmentation** (Donut Chart)
   - Values: RFM Segments
   - Colors: Champions (Gold), Loyal (Blue), New (Green), At Risk (Orange), Hibernating (Red)

2. **Customer Retention** (Line Chart)
   - X-axis: Month
   - Y-axis: Retention Rate %
   - Lines: Cohort groups

3. **Churn Risk by Segment** (Stacked Bar Chart)
   - X-axis: Customer Segment
   - Y-axis: Customer Count
   - Legend: Churn Status

4. **Top 10 Customers** (Table)
   - Columns: Customer Name, Email, Total Spent, Orders, Last Order, Segment

5. **Days Since Last Purchase** (Histogram)
   - X-axis: Days
   - Y-axis: Customer Count

### Page 3: Product Performance

**Visuals**:
1. **Top 10 Products by Revenue** (Horizontal Bar Chart)
   - Y-axis: Product Name
   - X-axis: Revenue
   - Color: Category

2. **Top 10 Products by Quantity** (Horizontal Bar Chart)
   - Y-axis: Product Name
   - X-axis: Quantity Sold

3. **Category Performance** (Treemap)
   - Values: Revenue
   - Group: Category

4. **Product Rating Distribution** (Column Chart)
   - X-axis: Rating (1-5)
   - Y-axis: Count

5. **Low Stock Alerts** (Table)
   - Columns: Product Name, Current Stock, Reorder Level, Status

### Page 4: Sales Trends

**Visuals**:
1. **Monthly Revenue Trend** (Line Chart)
   - X-axis: Month
   - Y-axis: Revenue
   - Lines: Year

2. **Revenue by Category** (Stacked Area Chart)
   - X-axis: Month
   - Y-axis: Revenue
   - Legend: Category

3. **Orders by Day of Week** (Column Chart)
   - X-axis: Day
   - Y-axis: Order Count

4. **Orders by Hour** (Heatmap)
   - X-axis: Hour
   - Y-axis: Day of Week
   - Values: Order Count

5. **Average Order Value Trend** (Line Chart)
   - X-axis: Month
   - Y-axis: AOV

### Page 5: Regional Analysis

**Visuals**:
1. **Sales by State** (Map)
   - Values: Revenue
   - Color: Revenue amount

2. **Sales by City** (Bar Chart)
   - X-axis: City
   - Y-axis: Revenue

3. **Regional Customer Distribution** (Pie Chart)
   - Values: Customer Count
   - Category: State

4. **Top Products by Region** (Matrix)
   - Rows: Product
   - Columns: State
   - Values: Revenue

## 🔌 Power BI Data Model

### Tables to Import

1. **customers**
   - customer_id
   - first_name
   - last_name
   - email
   - address_city
   - address_state
   - customer_segment
   - registration_date

2. **orders**
   - order_id
   - order_number
   - customer_id
   - order_date
   - status
   - total_amount
   - payment_method

3. **products**
   - product_id
   - product_name
   - category_id
   - price
   - stock_quantity
   - rating_avg

4. **categories**
   - category_id
   - category_name

5. **order_items**
   - order_item_id
   - order_id
   - product_id
   - quantity
   - total_price

### Relationships

```
customers (1) ----< (N) orders
orders (1) ----< (N) order_items
products (1) ----< (N) order_items
categories (1) ----< (N) products
```

## 📐 DAX Measures

### Revenue Measures

```dax
// Total Revenue
Total Revenue = SUM(orders[total_amount])

// Revenue MTD
Revenue MTD = TOTALMTD([Total Revenue], 'Calendar'[Date])

// Revenue YTD
Revenue YTD = TOTALYTD([Total Revenue], 'Calendar'[Date])

// Revenue vs Last Month
Revenue vs Last Month =
VAR CurrentMonth = [Total Revenue]
VAR LastMonth = CALCULATE([Total Revenue], DATEADD('Calendar'[Date], -1, MONTH))
RETURN
DIVIDE(CurrentMonth - LastMonth, LastMonth)

// Revenue vs Last Year
Revenue vs Last Year =
VAR CurrentYear = [Total Revenue]
VAR LastYear = CALCULATE([Total Revenue], SAMEPERIODLASTYEAR('Calendar'[Date]))
RETURN
DIVIDE(CurrentYear - LastYear, LastYear)
```

### Customer Measures

```dax
// Total Customers
Total Customers = DISTINCTCOUNT(orders[customer_id])

// Active Customers (30 days)
Active Customers 30D =
CALCULATE(
    [Total Customers],
    FILTER(ALL('Calendar'), 'Calendar'[Date] >= TODAY() - 30)
)

// New Customers
New Customers =
CALCULATE(
    [Total Customers],
    FILTER(customers, customers[registration_date] >= TODAY() - 30)
)

// Churn Rate
Churn Rate =
VAR TotalCust = [Total Customers]
VAR ChurnedCust =
    COUNTROWS(
        FILTER(
            customers,
            DATEDIFF(TODAY(), customers[last_login], DAY) > 90
        )
    )
RETURN
DIVIDE(ChurnedCust, TotalCust)
```

### Order Measures

```dax
// Total Orders
Total Orders = COUNT(orders[order_id])

// Average Order Value
Average Order Value = DIVIDE([Total Revenue], [Total Orders])

// Orders MTD
Orders MTD = TOTALMTD([Total Orders], 'Calendar'[Date])

// Conversion Rate
Conversion Rate =
DIVIDE([Total Orders], [Total Customers])
```

### Product Measures

```dax
// Total Products Sold
Total Products Sold = SUM(order_items[quantity])

// Average Product Price
Average Product Price = AVERAGE(products[price])

// Top Products Revenue
Top Products Revenue =
TOPN(10, ALL(products), [Total Revenue], DESC)
```

## 🎨 Color Palette

```powerbi
// Primary Colors
Primary Blue = #2563EB
Secondary Blue = #3B82F6
Light Blue = #93C5FD

// Status Colors
Success Green = #10B981
Warning Amber = #F59E0B
Danger Red = #EF4444
Info Gray = #6B7280

// Segment Colors
Champions Gold = #F59E0B
Loyal Blue = #3B82F6
New Green = #10B981
At Risk Orange = #F97316
Hibernating Red = #EF4444
```

## 📱 Mobile Layout

### Phone View

1. **KPI Row**: 2 cards per row
2. **Main Chart**: Full width
3. **Secondary Charts**: Stacked vertically
4. **Tables**: Scrollable with key columns only

## 🔄 Refresh Schedule

- **Data Refresh**: Daily at 6:00 AM
- **Incremental Refresh**: Enabled for orders table
- **History**: Keep 2 years of data

## 🚀 Deployment Steps

1. **Publish to Power BI Service**
   - File → Publish → Select workspace
   - Configure data source credentials
   - Set up refresh schedule

2. **Configure Row-Level Security**
   - Create roles for different user groups
   - Test security roles
   - Assign users to roles

3. **Set Up Alerts**
   - Revenue threshold alerts
   - Low stock alerts
   - Churn rate alerts

4. **Create Subscriptions**
   - Daily executive summary
   - Weekly performance report
   - Monthly deep dive

## 📊 Sample Dashboard Layout

```
┌─────────────────────────────────────────────────────────┐
│  E-Commerce Analytics    [Date: ▼] [Refresh: 🔄]       │
├─────────────────────────────────────────────────────────┤
│  $52,848  │  60  │  20  │  $881  │  15%  │  2.3%  │
│  Revenue  │ Ord │ Cust │  AOV  │ Churn │ Conv  │
├─────────────────────────────────────────────────────────┤
│  [Revenue Trend Line Chart - Full Width]                │
├──────────────────┬──────────────────────────────────────┤
│  [Order Vol Bar]  │  [Customer Growth Area]             │
├──────────────────┴──────────────────────────────────────┤
│  [Top Products Table]    [Customer Segment Donut]       │
│                          [Regional Map]                 │
└─────────────────────────────────────────────────────────┘
```

## 💡 Tips

1. **Performance**: Use DirectQuery for large datasets
2. **Interactivity**: Enable cross-filtering between visuals
3. **Tooltips**: Add detailed information to all visuals
4. **Bookmarks**: Create different views for different audiences
5. **Drill-through**: Enable drill-through to detailed pages

---

**Last Updated**: 2026-05-13
**Version**: 1.0
