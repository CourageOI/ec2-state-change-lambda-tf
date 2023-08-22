resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "cloudtrail-logs-test"
  acl = "private"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowCloudTrailToWriteLogs",
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.cloudtrail_logs.arn}",
          "${aws_s3_bucket.cloudtrail_logs.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_cloudtrail" "cloudtrail_logs_test" {
  name     = "cloudtrail-default"
  s3_bucket_name = aws_s3_bucket.cloudtrail_logs.id
  enable_log_file_validation = true

  event_selector {
    read_write_type = "All"
    include_management_events = true
  }
}