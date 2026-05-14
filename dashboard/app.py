import streamlit as st
import pandas as pd
import plotly.express as px

st.set_page_config(page_title='E-Commerce Analytics Dashboard', layout='wide')

st.title('E-Commerce Customer Analytics Dashboard')

@st.cache_data
def load_data():
    customer = pd.read_csv('../data/processed/customer_features.csv')
    product = pd.read_csv('../data/processed/product_popularity.csv')
    monthly = pd.read_csv('../data/processed/monthly_revenue.csv')
    return customer, product, monthly

customer, product, monthly = load_data()

k1, k2, k3 = st.columns(3)
k1.metric('Customers', len(customer))
k2.metric('Total Revenue', f"${monthly['Total Revenue'].sum():,.0f}")
k3.metric('Products', len(product))

st.subheader('Revenue Trend')
monthly['Year-Month'] = pd.to_datetime(monthly['Year-Month'])
fig = px.line(monthly, x='Year-Month', y='Total Revenue')
st.plotly_chart(fig, use_container_width=True)

c1, c2 = st.columns(2)
with c1:
    st.subheader('Top Products')
    top = product.sort_values('total_revenue', ascending=False).head(10)
    fig2 = px.bar(top, x='product_id', y='total_revenue')
    st.plotly_chart(fig2, use_container_width=True)
with c2:
    st.subheader('Customer Segments')
    if 'customer_segment' in customer.columns:
        fig3 = px.pie(customer, names='customer_segment')
        st.plotly_chart(fig3, use_container_width=True)

st.subheader('Customer Data Preview')
st.dataframe(customer.head(50))
