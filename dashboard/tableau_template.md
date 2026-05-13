# E-Commerce Analytics Dashboard - Tableau Template

## Dashboard Overview

This document provides a complete template for creating an E-Commerce Analytics Dashboard in Tableau.

## 📊 Dashboard Pages

### Page 1: Executive Summary

**Layout**: 4 KPI cards (top), 2 large charts (middle), 2 smaller charts (bottom)

**Visuals**:
1. **KPI Cards** (4 across)
   - Total Revenue (Big Number format)
   - Total Orders (Big Number format)
   - Active Customers (Big Number format)
   - Average Order Value (Big Number format)

2. **Revenue Trend** (Large Line Chart)
   - Columns: Month (continuous)
   - Rows: Revenue (SUM)
   - Color: Year
   - Tooltip: Revenue, Orders, Customers

3. **Order Volume** (Bar Chart)
   - Columns: Month
   - Rows: Order Count (COUNT)
   - Color: Status

4. **Customer Growth** (Area Chart)
   - Columns: Month
   - Rows: Running SUM of Customers

### Page 2: Customer Analytics

**Layout**: Donut chart (left), Line chart (top right), Table (bottom right)

**Visuals**:
1. **Customer Segmentation** (Donut Chart)
   - Marks: Pie
   - Color: RFM Segment
   - Size: Count of Customers
   - Label: Segment name and percentage

2. **Customer Retention** (Line Chart)
   - Columns: Cohort Month
   - Rows: Retention Rate
   - Color: Cohort Group
   - Path: Cohort Month

3. **Churn Risk by Segment** (Stacked Bar Chart)
   - Columns: Customer Segment
   - Rows: Customer Count
   - Color: Churn Status

4. **Top 10 Customers** (Table)
   - Columns: Customer Name, Email, Total Spent, Orders, Last Order, Segment
   - Sorting: Total Spent (descending)

### Page 3: Product Performance

**Layout**: 2 horizontal bar charts (top), Treemap (bottom left), Table (bottom right)

**Visuals**:
1. **Top 10 Products by Revenue** (Horizontal Bar Chart)
   - Rows: Product Name
   - Columns: Revenue (SUM)
   - Color: Category
   - Label: Revenue amount

2. **Top 10 Products by Quantity** (Horizontal Bar Chart)
   - Rows: Product Name
   - Columns: Quantity Sold (SUM)
   - Color: Category

3. **Category Performance** (Treemap)
   - Marks: Square
   - Size: Revenue (SUM)
   - Color: Category
   - Label: Category name and revenue

4. **Low Stock Alerts** (Table)
   - Columns: Product Name, Current Stock, Reorder Level, Status
   - Conditional formatting: Stock level

### Page 4: Sales Trends

**Layout**: Line chart (top), Stacked area (middle left), Heatmap (middle right), Line chart (bottom)

**Visuals**:
1. **Monthly Revenue Trend** (Line Chart)
   - Columns: Month (continuous)
   - Rows: Revenue (SUM)
   - Color: Year
   - Reference Line: Average revenue

2. **Revenue by Category** (Stacked Area Chart)
   - Columns: Month
   - Rows: Revenue (SUM)
   - Color: Category

3. **Orders by Day of Week** (Column Chart)
   - Columns: Day of Week
   - Rows: Order Count (COUNT)
   - Color: Day of Week

4. **Orders by Hour** (Heatmap)
   - Columns: Hour
   - Rows: Day of Week
   - Color: Order Count (COUNT)
   - Marks: Square

5. **Average Order Value Trend** (Line Chart)
   - Columns: Month
   - Rows: AOV (calculated field)
   - Reference Line: Average AOV

### Page 5: Regional Analysis

**Layout**: Map (top left), Bar chart (top right), Pie chart (bottom left), Matrix (bottom right)

**Visuals**:
1. **Sales by State** (Map)
   - Marks: Map
   - Color: Revenue (SUM)
   - Size: Order Count
   - Tooltip: State, Revenue, Orders, Customers

2. **Sales by City** (Bar Chart)
   - Columns: City
   - Rows: Revenue (SUM)
   - Color: State

3. **Regional Customer Distribution** (Pie Chart)
   - Marks: Pie
   - Color: State
   - Size: Customer Count

4. **Top Products by Region** (Matrix)
   - Rows: Product Name
   - Columns: State
   - Values: Revenue (SUM)
   - Color: Revenue amount

## 🔌 Tableau Data Source

### Connection Type

**Option 1: SQLite (Recommended for Development)**
- Data Source: SQLite
- File: `data/sql/ecommerce.db`

**Option 2: MySQL (Production)**
- Data Source: MySQL
- Server: localhost
- Database: ecommerce_analytics
- Authentication: Username/Password

### Data Relationships

```
customers (1) ----< (N) orders
orders (1) ----< (N) order_items
products (1) ----< (N) order_items
categories (1) ----< (N) products
```

### Relationship Type

Use **Relationships** (not joins) for:
- customers → orders
- orders → order_items
- products → order_items
- categories → products

## 📐 Calculated Fields

### Revenue Calculations

```tableau
// Total Revenue
[Total Revenue] = SUM([total_amount])

// Revenue MTD
[Revenue MTD] = TOTAL(SUM([total_amount])) -
                LOOKUP(TOTAL(SUM([total_amount])), -1)

// Revenue YTD
[Revenue YTD] = WINDOW_SUM(SUM([total_amount]), 0, IIF(FIRST()==0, LAST(), 0))

// Revenue vs Last Month
[Revenue vs Last Month] =
(SUM([total_amount]) - LOOKUP(SUM([total_amount]), -1)) /
ABS(LOOKUP(SUM([total_amount]), -1))

// Revenue vs Last Year
[Revenue vs Last Year] =
(SUM([total_amount]) - LOOKUP(SUM([total_amount]), -12)) /
ABS(LOOKUP(SUM([total_amount]), -12))
```

### Customer Calculations

```tableau
// Total Customers
[Total Customers] = COUNTD([customer_id])

// Active Customers (30 days)
[Active Customers 30D] =
COUNTD(IF DATEDIFF('day', [last_login], TODAY()) <= 30 THEN [customer_id] END)

// New Customers
[New Customers] =
COUNTD(IF DATEDIFF('day', [registration_date], TODAY()) <= 30 THEN [customer_id] END)

// Churn Rate
[Churn Rate] =
COUNTD(IF DATEDIFF('day', [last_login], TODAY()) > 90 THEN [customer_id] END) /
COUNTD([customer_id])

// Days Since Last Purchase
[Days Since Last Purchase] =
DATEDIFF('day', [last_order_date], TODAY())

// Churn Status
[Churn Status] =
IF [Days Since Last Purchase] > 90 THEN 'Churned'
ELSEIF [Days Since Last Purchase] > 60 THEN 'At Risk'
ELSE 'Active'
END
```

### Order Calculations

```tableau
// Total Orders
[Total Orders] = COUNT([order_id])

// Average Order Value
[Average Order Value] = [Total Revenue] / [Total Orders]

// Orders MTD
[Orders MTD] = COUNT(IF [order_date] >= DATETRUNC('month', TODAY()) THEN [order_id] END)

// Conversion Rate
[Conversion Rate] = [Total Orders] / [Total Customers]
```

### Product Calculations

```tableau
// Total Products Sold
[Total Products Sold] = SUM([quantity])

// Average Product Price
[Average Product Price] = AVG([price])

// Product Rating
[Product Rating] = AVG([rating_avg])

// Low Stock Status
[Low Stock Status] =
IF [stock_quantity] <= [reorder_level] THEN 'Low Stock'
ELSEIF [stock_quantity] <= [reorder_level] * 2 THEN 'Medium Stock'
ELSE 'In Stock'
END
```

### RFM Calculations

```tableau
// Recency Score
[Recency Score] =
IF [Days Since Last Purchase] <= 30 THEN 5
ELSEIF [Days Since Last Purchase] <= 60 THEN 4
ELSEIF [Days Since Last Purchase] <= 90 THEN 3
ELSEIF [Days Since Last Purchase] <= 180 THEN 2
ELSE 1
END

// Frequency Score
[Frequency Score] =
IF [Order Count] >= 10 THEN 5
ELSEIF [Order Count] >= 5 THEN 4
ELSEIF [Order Count] >= 3 THEN 3
ELSEIF [Order Count] >= 2 THEN 2
ELSE 1
END

// Monetary Score
[Monetary Score] =
IF [Total Spent] >= 5000 THEN 5
ELSEIF [Total Spent] >= 2000 THEN 4
ELSEIF [Total Spent] >= 1000 THEN 3
ELSEIF [Total Spent] >= 500 THEN 2
ELSE 1
END

// RFM Segment
[RFM Segment] =
IF [Recency Score] >= 4 AND [Frequency Score] >= 4 THEN 'Champions'
ELSEIF [Recency Score] >= 3 AND [Frequency Score] >= 3 THEN 'Loyal Customers'
ELSEIF [Recency Score] >= 4 AND [Frequency Score] <= 2 THEN 'New Customers'
ELSEIF [Recency Score] <= 2 AND [Frequency Score] >= 4 THEN 'At Risk'
ELSEIF [Recency Score] <= 2 AND [Frequency Score] <= 2 AND [Monetary Score] >= 4 THEN "Can't Lose Them"
ELSEIF [Recency Score] >= 3 THEN 'About to Sleep'
ELSE 'Hibernating'
END
```

## 🎨 Color Palette

### Custom Colors

```tableau
// Segment Colors
Champions = #F59E0B (Amber)
Loyal Customers = #3B82F6 (Blue)
New Customers = #10B981 (Green)
At Risk = #F97316 (Orange)
Hibernating = #EF4444 (Red)

// Status Colors
Active = #10B981 (Green)
At Risk = #F59E0B (Amber)
Churned = #EF4444 (Red)

// Category Colors
Electronics = #3B82F6 (Blue)
Home & Garden = #10B981 (Green)
Sports & Outdoors = #F59E0B (Amber)
Clothing = #8B5CF6 (Purple)
Books = #EC4899 (Pink)
```

## 📱 Device Specific Layouts

### Desktop Layout
- Size: 1200 x 800 pixels
- Orientation: Landscape
- Fit: Standard

### Tablet Layout
- Size: 1024 x 768 pixels
- Orientation: Landscape
- Fit: Standard

### Phone Layout
- Size: 375 x 667 pixels
- Orientation: Portrait
- Fit: Entire View

## 🔄 Data Refresh

### Extract Refresh Schedule
- **Frequency**: Daily
- **Time**: 6:00 AM
- **Incremental Refresh**: Enabled for orders table

### Live Connection
- **Data Source**: Live (for real-time updates)
- **Performance**: Use extracts for large datasets

## 🚀 Publishing Steps

### 1. Prepare for Publishing
- Hide unused fields
- Optimize calculations
- Set appropriate data source filters
- Test all interactions

### 2. Publish to Tableau Server/Online
- File → Publish to Tableau Server/Online
- Select project
- Configure data source credentials
- Set refresh schedule

### 3. Configure Permissions
- Set view permissions
- Configure download options
- Set commenting permissions
- Configure web editing

### 4. Set Up Subscriptions
- Create subscription views
- Set schedule (daily/weekly)
- Configure email format
- Add recipients

## 💡 Tips and Best Practices

### Performance Optimization
1. Use extracts instead of live connections for large datasets
2. Minimize the number of data sources
3. Use context filters to improve performance
4. Avoid complex calculations in filters
5. Use data source filters instead of extract filters

### Design Best Practices
1. Keep dashboards simple and focused
2. Use consistent color schemes
3. Limit the number of marks on a view
4. Use appropriate chart types for the data
5. Add clear titles and labels

### Interactivity
1. Enable filter actions between sheets
2. Use highlight actions for related data
3. Add URL actions for drill-through
4. Use parameters for user input
5. Create tooltip actions for details

## 📊 Sample Dashboard Layout

```
┌─────────────────────────────────────────────────────────┐
│  E-Commerce Analytics    [Date: ▼] [Refresh: 🔄]       │
├─────────────────────────────────────────────────────────┤
│  $52,848  │  60  │  20  │  $881                        │
│  Revenue  │ Ord │ Cust │  AOV                         │
├─────────────────────────────────────────────────────────┤
│  [Revenue Trend Line Chart - Full Width]                │
├──────────────────┬──────────────────────────────────────┤
│  [Order Vol Bar]  │  [Customer Growth Area]             │
├──────────────────┴──────────────────────────────────────┤
│  [Top Products Table]    [Customer Segment Donut]       │
│                          [Regional Map]                 │
└─────────────────────────────────────────────────────────┘
```

## 🔧 Troubleshooting

### Common Issues

**Issue: Slow dashboard performance**
- Solution: Use extracts, reduce data volume, optimize calculations

**Issue: Data not refreshing**
- Solution: Check refresh schedule, verify data source credentials

**Issue: Filters not working**
- Solution: Check filter configuration, verify data relationships

**Issue: Incorrect calculations**
- Solution: Review calculated field syntax, check data types

---

**Last Updated**: 2026-05-13
**Version**: 1.0
