
resource "random_id" "randomise" {
  byte_length = 8
}

resource "aws_s3_bucket" "test_s3_bucket" {
    bucket = "${var.bucket_name}-${random_id.randomise.hex}"
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