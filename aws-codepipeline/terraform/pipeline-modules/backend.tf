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

resource "aws_dynamodb_table" "terraform-lock" {
    name           = "terraform-state-fg"
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