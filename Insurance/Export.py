import pandas as pd
import boto3
import os
from sqlalchemy import create_engine

# ---- Connect to Snowflake with Error Handling ----

user= os.eniron.get("USER")
password=os.eniron.get("PASSWORD")
account= os.eniron.get("ACCOUNT")
warehouse=os.eniron.get("WAREHOUSE")
database=os.eniron.get("DATABASE")
schema=os.eniron.get("SCHEMA")
connection_string = (
    f"snowflake://{user}:{password}@{account}/{database}/{schema}?warehouse={warehouse}"
)

try:
    engine = create_engine(connection_string)
    connection = engine.connect()
    print("✅ Successfully connected to Snowflake via SQLAlchemy.")

    query = "SELECT * FROM policy_summary LIMIT 100"
    df = pd.read_sql(query, connection)
    connection.close()

except Exception as e:
    print("❌ Snowflake connection or query failed.")
    print("Error:", e)
    exit(1)

# ---- Save to CSV ----
csv_filename = "policy_summary"
df.to_csv(csv_filename, index=False)

# ---- Upload CSV to S3 ----
try:
    s3 = boto3.client(
        's3',
        aws_access_key_id= os.environ.get("AWS_ACCESS_KEY_ID"),
        aws_secret_access_key=os.environ.get("AWS_SECRET_ACCESS_KEY"),
        region_name='ap-south-1'  # or your preferred region
    )

    bucket_name = 'mydbtproject-2'
    s3_key = f'reports/{csv_filename}.csv'

    s3.upload_file(csv_filename, bucket_name, s3_key)
    print(f"✅ CSV uploaded to s3://{bucket_name}/{s3_key}")

except Exception as e:
    print("❌ Failed to upload CSV to S3.")
    print("Error:", e)
