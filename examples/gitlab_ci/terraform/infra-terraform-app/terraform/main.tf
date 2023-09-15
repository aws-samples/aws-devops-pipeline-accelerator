
resource "random_id" "randomise" {
  byte_length = 8
}

resource "aws_s3_bucket" "test_s3_bucket" {
    bucket = "${var.bucket_name}-${random_id.randomise.hex}"
    versioning {
      enabled    = true
    }
    replication_configuration {
      role = aws_iam_role.replication.arn
      rules {
        id     = "test_s3_bucket_rules"
        prefix = "test_s3"
        status = "Enabled"

        destination {
          bucket        = aws_s3_bucket.destination.arn
          storage_class = "STANDARD"
        }
      }
    }
    lifecycle_rule {
      id      = "test_s3_bucket_permanent_retention"
      enabled = true
      prefix  = "permanent/"

      transition {
          days            = 1
          storage_class   = "GLACIER"
      }
    }
    server_side_encryption_configuration {
      rule {
          apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
          }
      }
   }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "test_s3_bucket_server_side_encryption" {
  bucket = aws_s3_bucket.test_s3_bucket.bucket

   rule {
     apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
     }
   }
 }

data "aws_iam_policy_document" "test_s3_bucket_topic" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions   = ["SNS:Publish"]
    resources = ["arn:aws:sns:*:*:s3-event-notification-topic"]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.test_s3_bucket.arn]
    }
  }
}
resource "aws_sns_topic" "test_s3_bucket_topic" {
  name   = "s3-event-notification-topic"
  policy = data.aws_iam_policy_document.test_s3_bucket_topic.json
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_s3_bucket_notification" "test_s3_bucket_notification" {
  bucket = aws_s3_bucket.test_s3_bucket.id

  topic {
    topic_arn     = aws_sns_topic.test_s3_bucket_topic.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
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

  versioning {
      enabled    = true
  }

  replication_configuration {
    role = aws_iam_role.replication.arn
    rules {
      id     = "test_s3_bucket_logging"
      prefix = "test_s3_logging"
      status = "Enabled"

      destination {
        bucket        = aws_s3_bucket.destination.arn
        storage_class = "STANDARD"
      }
    }
  }
  lifecycle_rule {
    id      = "logging_bucket_permanent_retention"
    enabled = true
    prefix  = "permanent/"

    transition {
        days            = 1
        storage_class   = "GLACIER"
    }
  }
  server_side_encryption_configuration {
    rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = aws_kms_key.mykey.arn
          sse_algorithm     = "aws:kms"
        }
    }
   }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "logging_bucket_server_side_encryption" {
  bucket = aws_s3_bucket.logging_bucket.bucket

   rule {
     apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
     }
   }
 }

data "aws_iam_policy_document" "logging_bucket_topic" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions   = ["SNS:Publish"]
    resources = ["arn:aws:sns:*:*:s3-event-notification-topic"]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.logging_bucket.arn]
    }
  }
}
resource "aws_sns_topic" "logging_bucket_topic" {
  name   = "s3-event-notification-topic"
  policy = data.aws_iam_policy_document.logging_bucket_topic.json
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_s3_bucket_notification" "logging_bucket_notification" {
  bucket = aws_s3_bucket.logging_bucket.id

  topic {
    topic_arn     = aws_sns_topic.logging_bucket_topic.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }
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

resource "aws_s3_bucket_public_access_block" "logging_bucket_block" {
  bucket = aws_s3_bucket.logging_bucket.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}