provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "blinkit_etl" {
  bucket = "blinkit-etl-data"

  tags = {
    Environment = "dev"
    Project     = "BlinkitETL"
  }
}

resource "aws_s3_object" "folders" {
  for_each = toset([
    "raw/customers/",
    "raw/orders/",
    "raw/order_items/",
    "raw/products/",
    "raw/feedback/",
    "raw/marketing/",
    "processed/",
    "athena-results/"
  ])

  bucket = aws_s3_bucket.blinkit_etl.id
  key    = each.key
  content = ""
}

# Glue Database
resource "aws_glue_catalog_database" "blinkit" {
  name = "blinkit_datalake"
}

# IAM Role for Glue Crawler
resource "aws_iam_role" "glue_crawler_role" {
  name = "glue_crawler_blinkit_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Principal = {
        Service = "glue.amazonaws.com"
      }
      Effect = "Allow"
      Sid    = ""
    }]
  })
}

# Attach basic policies for Glue to access S3
resource "aws_iam_policy_attachment" "glue_crawler_policy_attach" {
  name       = "glue-crawler-s3-access"
  roles      = [aws_iam_role.glue_crawler_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "glue_s3_read_access" {
  name = "glue_s3_read_access"
  role = aws_iam_role.glue_crawler_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.blinkit_etl.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.blinkit_etl.bucket}/*"
        ]
      }
    ]
  })
}

locals {
  folders = [
    "customers",
    "orders",
    "order_items",
    "products",
    "feedback",
    "marketing"
  ]
}

# Create one crawler per folder
resource "aws_glue_crawler" "blinkit_crawlers" {
  for_each = toset(local.folders)

  name          = "blinkit_${each.key}_crawler"
  role          = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.blinkit.name
  table_prefix  = "${each.key}_"

  s3_target {
    path = "s3://${aws_s3_bucket.blinkit_etl.bucket}/raw/${each.key}/"
  }
}

