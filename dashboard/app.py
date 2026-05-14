import streamlit as st
import pandas as pd
import numpy as np
import plotly.express as px

st.set_page_config(
    page_title="E-Commerce Analytics Dashboard",
    layout="wide"
)

st.title("E-Commerce Customer Analytics Dashboard")

@st.cache_data
def generate_demo_data():
    np.random.seed(42)

    monthly_dates = pd.date_range("2024-01-01", periods=12, freq="M")

    monthly = pd.DataFrame({
        "Year-Month": monthly_dates,
        "Total Revenue": np.random.randint(50000, 200000, 12),
        "Total Orders": np.random.randint(500, 2500, 12)
    })

    customer_segments = pd.DataFrame({
        "customer_segment": np.random.choice(
            ["High Value", "Regular", "At Risk", "New"],
            1000
        )
    })

    products = pd.DataFrame({
        "product_name": [f"Product {i}" for i in range(1, 21)],
        "total_revenue": np.random.randint(10000, 100000, 20)
    })

    churn = pd.DataFrame({
        "model": ["Logistic Regression", "Random Forest", "XGBoost"],
        "roc_auc": [0.81, 0.89, 0.92]
    })

    forecast = monthly.copy()
    forecast["Predicted Revenue"] = (
        forecast["Total Revenue"] * np.random.uniform(0.95, 1.08, 12)
    )

    return monthly, customer_segments, products, churn, forecast

monthly, customer_segments, products, churn, forecast = generate_demo_data()

# KPIs
k1, k2, k3 = st.columns(3)

k1.metric(
    "Total Revenue",
    f"${monthly['Total Revenue'].sum():,}"
)

k2.metric(
    "Total Orders",
    f"{monthly['Total Orders'].sum():,}"
)

k3.metric(
    "Customers",
    "1,000"
)

# Revenue trend
st.subheader("Revenue Trend")

fig1 = px.line(
    monthly,
    x="Year-Month",
    y="Total Revenue",
    markers=True
)

st.plotly_chart(fig1, use_container_width=True)

# Two-column charts
c1, c2 = st.columns(2)

with c1:
    st.subheader("Top Products")

    top_products = products.sort_values(
        "total_revenue",
        ascending=False
    ).head(10)

    fig2 = px.bar(
        top_products,
        x="product_name",
        y="total_revenue"
    )

    st.plotly_chart(fig2, use_container_width=True)

with c2:
    st.subheader("Customer Segmentation")

    fig3 = px.pie(
        customer_segments,
        names="customer_segment"
    )

    st.plotly_chart(fig3, use_container_width=True)

# Churn model comparison
st.subheader("Churn Model Performance")

fig4 = px.bar(
    churn,
    x="model",
    y="roc_auc"
)

st.plotly_chart(fig4, use_container_width=True)

# Forecast
st.subheader("Sales Forecast")

fig5 = px.line(
    forecast,
    x="Year-Month",
    y=["Total Revenue", "Predicted Revenue"],
    markers=True
)

st.plotly_chart(fig5, use_container_width=True)
