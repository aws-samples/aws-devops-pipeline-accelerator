
resource "random_id" "randomise" {
  byte_length = 8
}

resource "aws_s3_bucket" "test_s3_bucket" {
    bucket = "${var.bucket_name}-${random_id.randomise.hex}"
    versioning {
      enabled    = true
    }
}

resource "aws_s3_bucket_ownership_controls" "test_bucket_ownership_controls" {
  bucket = aws_s3_bucket.test_s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "test_s3_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.test_bucket_ownership_controls]

  bucket = aws_s3_bucket.test_s3_bucket.id
  acl    = "${var.acl_value}" 
}

resource "aws_s3_bucket" "logging_bucket" {
  bucket = "${var.bucket_name}-${random_id.randomise.hex}-logging"
}
resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.logging_bucket.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_logging" "test_s3_bucket_logging" {
  bucket = aws_s3_bucket.test_s3_bucket.id
  target_bucket = aws_s3_bucket.logging_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_public_access_block" "test_s3_bucket_block" {
  bucket = aws_s3_bucket.test_s3_bucket.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}