/*# Backend must remain commented until the Bucket
and the DynamoDB table are created. 
After the creation you can uncomment it,
run "terraform init" and then "terraform apply" */

terraform {
  backend "s3" {
    bucket         = "terraform-state-fg"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-fg"
    encrypt        = true
  }
}

resource "aws_s3_bucket" "bucket" {
    bucket = "terraform-state-fg"
      #checkov:skip=CKV_AWS_18:Ensure the S3 bucket has access logging enabled
      #checkov:skip=CKV2_AWS_61:Ensure that an S3 bucket has a lifecycle configuration
      #checkov:skip=CKV_AWS_145:Ensure that S3 buckets are encrypted with KMS by default
      #checkov:skip=CKV2_AWS_62:Ensure S3 buckets should have event notifications enabled
      #checkov:skip=CKV_AWS_144:Ensure that S3 bucket has cross-region replication enabled
    object_lock_enabled = true
    tags = {
        Name = "S3 Remote Terraform State Store"
    }
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls   = true
  block_public_policy = true
  restrict_public_buckets = true
  ignore_public_acls  = true
}

resource "aws_dynamodb_table" "terraform-lock" {
    name           = "terraform-state-fg"
      #checkov:skip=CKV_AWS_28:Ensure Dynamodb point in time recovery (backup) is enabled
      #checkov:skip=CKV_AWS_119:Ensure DynamoDB Tables are encrypted using a KMS Customer Managed CMK
      #checkov:skip=CKV2_AWS_16:Ensure that Auto Scaling is enabled on your DynamoDB tables
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
    tags = {
        "Name" = "DynamoDB Terraform State Lock Table"
    }
}