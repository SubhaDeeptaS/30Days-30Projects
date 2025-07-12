# 🏢 Insurance Analytics Pipeline

This project implements an **end-to-end data pipeline** using AWS S3, SQS, Snowpipe, Snowflake, DBT, and Power BI to analyse customer insurance data.

---

## 📌 Tech Stack

- **AWS S3**: Raw JSON data storage  
- **AWS SQS**: Triggers for data events  
- **Snowpipe**: Automated data loading into Snowflake  
- **Snowflake**: Cloud data warehouse  
- **Streams & Tasks**: CDC-based transformation in Snowflake  
- **DBT**: Data modeling and transformation  
- **Power BI**: Data visualization and analytics  

---

## 🚀 Step-by-Step Implementation

### 1. 📥 Upload JSON Files to S3

- Created raw JSON files for `customers`, `addresses`, `policies`, `claims`, and `payments`.
- Uploaded them to a specific S3 bucket (`s3://your-bucket-name/insurance/`).

### 2. 📬 Set Up SQS Notifications

- Configured **S3 Event Notifications** to trigger on new object uploads.
- S3 sends the file event to an **SQS queue**.

### 3. 🛠 Snowpipe Configuration

- Snowpipe listens to the SQS queue and auto-ingests JSON files into a **raw table** that stored all the JSONs alongwith the timestamp at which they came into the table.

### 4. 🔄 Snowflake Streams & Tasks

- Created **streams** on the raw table to track changes.
- Created **tasks** to insert transformed rows into curated tables using SQL logic.
- Resulting tables:
  - `dcustomer`, `address`
  - `policy`, `claims`, `payment`

### 5. 🧱 DBT Transformations

- Used **DBT** to define transformations in the `models/` directory.
- Built a star-schema with:
  - `dim_customer`, `dim_address`
  - `fct_policy`, `fct_claim`, `fct_payment`
  - `mart_policy_summary` (combined analytics table)
- Defined tests and relationships in `schema.yml`.

### 6. 📊 Power BI Reporting

- Connected Power BI to the Snowflake database.
- Built dashboards to analyze:
  - Policy status by region
  - Claims and payments over time
  - Customer demographics and policy types

---

## 📌 Future Improvements

- Add DBT snapshots for historical tracking  
- Introduce role-based access controls in Snowflake  
- Automate tests and CI/CD for DBT using GitHub Actions  
