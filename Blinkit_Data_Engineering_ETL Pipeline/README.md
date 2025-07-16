Blinkit Data Engineering ETL Pipeline 🚀

This project sets up a fully automated ETL pipeline for Blinkit customer, orders, feedback, and marketing data using AWS S3, Glue, Athena, and Terraform.

🛠️ Architecture

- S3 stores raw and processed data

- Glue Crawlers catalog raw and processed datasets

- Glue Jobs transform raw data into clean Parquet tables

- Athena queries processed tables using SQL

🪠 Tools Used

- AWS S3 – Data lake storage

- AWS Glue – ETL jobs & crawlers

- AWS Athena – Query engine

- Terraform – Infrastructure as Code (IaC)

- PySpark – Transform logic in Glue jobs

