resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "cloudtrail-logs-test"
  acl = "private"
  force_destroy = true

  # Enable server-side encryption with default encryption key
  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = true
    }
  }

  # Add policy to allow CloudTrail to write logs to the bucket
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCloudTrailToWriteLogs",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListObject"
      ],
      "Resource": "${aws_s3_bucket.cloudtrail_logs.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_cloudtrail" "cloudtrail_logs-test" {
  name = "cloudtrail-default"
  bucket = aws_s3_bucket.cloudtrail_logs.bucket
  enable_log_file_validation = true

  # Configure CloudTrail to log all events
  trail_filter {
    name = "All"
  }
}
