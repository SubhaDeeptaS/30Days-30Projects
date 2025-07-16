import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrame

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Load raw data from S3
orders = glueContext.create_dynamic_frame.from_options(
    connection_type="s3",
    format="csv",
    connection_options={"paths": ["s3://blinkit-etl-data/raw/orders/"], "recurse": True},
    format_options={"withHeader": True}
)

customers = glueContext.create_dynamic_frame.from_options(
    connection_type="s3",
    format="csv",
    connection_options={"paths": ["s3://blinkit-etl-data/raw/customers/"], "recurse": True},
    format_options={"withHeader": True}
)

order_items = glueContext.create_dynamic_frame.from_options(
    connection_type="s3",
    format="csv",
    connection_options={"paths": ["s3://blinkit-etl-data/raw/order_items/"], "recurse": True},
    format_options={"withHeader": True}
)

products = glueContext.create_dynamic_frame.from_options(
    connection_type="s3",
    format="csv",
    connection_options={"paths": ["s3://blinkit-etl-data/raw/products/"], "recurse": True},
    format_options={"withHeader": True}
)

df_orders = orders.toDF()
df_customers = customers.toDF()
df_order_items = order_items.toDF()
df_products = products.toDF()

sales_df = df_orders \
    .join(df_customers, df_orders["customer_id"] == df_customers["customer_id"], "inner") \
    .join(df_order_items, df_orders["order_id"] == df_order_items["order_id"], "inner") \
    .join(df_products, df_order_items["product_id"] == df_products["product_id"], "inner") \
    .select(
        df_orders["order_id"],
        df_orders["order_date"],
        df_customers["customer_id"],
        df_customers["customer_name"],
        df_products["product_name"],
        df_products["category"],
        df_order_items["quantity"],
        df_order_items["price"],
        (df_order_items["quantity"].cast("int") * df_order_items["price"].cast("float")).alias("total_amount")
    )

sales_dynamic = DynamicFrame.fromDF(sales_df, glueContext, "sales_dynamic")
glueContext.write_dynamic_frame.from_options(
    frame=sales_dynamic,
    connection_type="s3",
    format="parquet",
    connection_options={"path": "s3://blinkit-etl-data/processed/fact_sales/", "partitionKeys": ["order_date"]}
)

feedback_dyf = glueContext.create_dynamic_frame.from_options(
    connection_type="s3",
    format="csv",
    connection_options={
        "paths": ["s3://blinkit-etl-data/raw/feedback/"],
        "recurse": True
    },
    format_options={"withHeader": True}
)

feedback_df = feedback_dyf.toDF()

feedback_df = feedback_df.filter(
    (feedback_df["feedback_text"].isNotNull()) &
    (feedback_df["feedback_text"] != "") &
    (feedback_df["feedback_text"].rlike(".*\\S.*"))
)


selected_df = feedback_df.select("customer_id", "feedback_text", "rating", "feedback_date")

cleaned_dyf = DynamicFrame.fromDF(selected_df, glueContext, "cleaned_dyf")


glueContext.write_dynamic_frame.from_options(
    frame=cleaned_dyf,
    connection_type="s3",
    format="parquet",
    connection_options={
        "path": "s3://blinkit-etl-data/processed/customer_feedback/",
        "partitionKeys": []
    }
)

job.commit()
