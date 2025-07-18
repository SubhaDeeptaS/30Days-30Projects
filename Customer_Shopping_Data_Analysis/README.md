
# 🛍️ Customer Shopping Data Analysis using DBT + Snowflake + Power BI

This project analyses customer shopping behaviour using a dataset comprising invoice records from a shopping mall. The data is cleaned, modelled, and then visualised using Power BI for insightful analytics.

## 📁 Dataset

The source dataset used is `customer_shopping_data.csv`, which contains the following columns:

- `invoice_no`: Unique identifier for each transaction
- `customer_id`: Unique ID for each customer
- `gender`: Gender of the customer
- `age`: Age of the customer
- `category`: Product category purchased
- `quantity`: Number of items bought
- `price`: Total price paid
- `payment_method`: Payment mode used
- `invoice_date`: Date of transaction
- `shopping_mall`: Name of the shopping mall

## ⚙️ Project Structure

### 1. **Seeding the Data**
The CSV file was seeded into DBT using the `dbt seed` feature. This feature helps to analyse statis files.

### 2. **Data Cleaning**
A DBT model (`shopping_cleaned`) was created to clean the raw seeded data. Custom **DBT macros** were used to:
- Standardize column formats
- Extract month and year from `invoice_date`
- Remove or handle invalid records

### 3. **Data Models**

The cleaned data was used to build the following analytical models:

#### 🔹 sales_by_category
- Aggregates total sales by product category.
```sql
select 
  round(sum(price), 2) as total_sales, 
  category 
from shopping
group by category
```

#### 🔹 sales_by_payment
- Analyzes total sales grouped by payment method.
```sql
select 
  sum(price) as total_sales, 
  payment_method 
from shopping
group by payment_method
```

#### 🔹 sales_by_month
- Tracks monthly sales performance over time.
```sql
select 
  sum(price) as total_sales, 
  month_of_purchase, 
  year_of_purchase 
from shopping_cleaned 
group by month_of_purchase, year_of_purchase
order by year_of_purchase, {{find_month('month_of_purchase')}}
```

> Note: The `find_month` macro was used to correctly sort months chronologically.

### 4. **Visualization**
The output DBT models were visualized using Power BI to answer key business questions such as:
- Which product categories generate the most revenue?
- What are the preferred payment methods of customers?
- How do monthly sales trend over time?

## 📊 Power BI Dashboard

The dashboard includes:
- Category-wise sales breakdown
- Monthly revenue trends
- Payment method preferences

## 🧰 Tools & Technologies

- **DBT** (Data Build Tool)
- **Power BI** for visualization
- **Jinja** templating with custom macros
- **Snowflake** / (Data warehouse)
- **CSV** data seeding

## ✅ Getting Started

1. Clone the repo
2. Place the `customer_shopping_data.csv` file in the `seeds/` directory inside DBT project folder
3. Run `dbt seed` to load the data
4. Execute `dbt run` to build models
5. Use the compiled tables to build visuals in Power BI
