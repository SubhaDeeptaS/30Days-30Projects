# Blinkit Data Engineering ETL Pipeline 🚀

This project sets up a fully automated ETL pipeline for Blinkit customer, orders, feedback, and marketing data using **AWS S3**, **Glue**, **Athena**, and **Terraform**.

---

## 🛠️ Architecture

```
blinkit-etl-data (S3)
├── raw/
│   ├── customers/
│   ├── orders/
│   ├── order_items/
│   ├── products/
│   ├── feedback/
│   └── marketing/
├── processed/
│   ├── fact_sales/
│   └── customer_feedback/
└── athena-results/
```

- **S3** stores raw and processed data
- **Glue Crawlers** catalog raw and processed datasets
- **Glue Jobs** transform raw data into clean Parquet tables
- **Athena** queries processed tables using SQL

---

## 📆 Components

### 📟 Files
| File                                 | Description                          |
|--------------------------------------|--------------------------------------|
| `blinkit_customers.csv`              | Raw customer data                    |
| `blinkit_orders.csv`                 | Raw order records                    |
| `blinkit_order_items.csv`            | Items in each order                  |
| `blinkit_products.csv`               | Product catalog                      |
| `blinkit_customer_feedback.csv`      | Customer feedback entries            |
| `blinkit_marketing_performance.csv`  | Campaign data                        |

---

## 🪠 Tools Used

- **AWS S3** – Data lake storage
- **AWS Glue** – ETL jobs & crawlers
- **AWS Athena** – Query engine
- **Terraform** – Infrastructure as Code (IaC)
- **PySpark** – Transform logic in Glue jobs

---

## 🚀 How to Deploy the Pipeline

### 1. Create Infrastructure with Terraform

Set up the S3 bucket, folders, Glue roles, Glue crawlers, and database:

```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

This will:
- Create `blinkit-etl-data` bucket
- Add folders under `raw/`, `processed/`, and `athena-results/`
- Create IAM role for Glue
- Create Glue database `blinkit_datalake`
- Deploy crawlers for each raw dataset

---

### 2. 📄 Upload Raw Data to S3

```bash
aws s3 cp blinkit_customers.csv s3://blinkit-etl-data/raw/customers/
aws s3 cp blinkit_orders.csv s3://blinkit-etl-data/raw/orders/
aws s3 cp blinkit_order_items.csv s3://blinkit-etl-data/raw/order_items/
aws s3 cp blinkit_products.csv s3://blinkit-etl-data/raw/products/
aws s3 cp blinkit_customer_feedback.csv s3://blinkit-etl-data/raw/feedback/
aws s3 cp blinkit_marketing_performance.csv s3://blinkit-etl-data/raw/marketing/
```

---

### 3. 📊 Run Glue Crawlers on Raw Data

```bash
aws glue start-crawler --name blinkit_customers_crawler
aws glue start-crawler --name blinkit_orders_crawler
# Repeat for each dataset
```

Check AWS Glue Data Catalog for new tables.

---

### 4. 🧲 Run Glue ETL Job (ETL_Glue_job.py)

Ensure your IAM role has `s3:PutObject` for `processed/` paths.

---

### 5. 📃 Crawl Processed Data

Create a crawler for:

```hcl
s3://blinkit-etl-data/processed/customer_feedback/
s3://blinkit-etl-data/processed/fact_sales/
```

Use Terraform or console, then run:

```bash
aws glue start-crawler --name blinkit_processed_feedback_crawler
```

---

### 6. 🔍 Query with Athena

```sql
SELECT * FROM blinkit_datalake.processed_customer_feedback LIMIT 10;
```

---

## 🔐 IAM Permissions

Ensure your IAM role includes:

```json
{
  "Effect": "Allow",
  "Action": [
    "s3:GetObject",
    "s3:ListBucket",
    "s3:PutObject",
    "s3:DeleteObject"
  ],
  "Resource": [
    "arn:aws:s3:::blinkit-etl-data",
    "arn:aws:s3:::blinkit-etl-data/*"
  ]
}
```

---

## 📆 Future Enhancements

- Add ETL pipelines for `dim_customer` etc.
- Automate job triggers with Lambda/EventBridge
- Integrate with Power BI or QuickSight dashboards

---
