resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "your-unique-cloudtrail-bucket-name"
}

resource "aws_s3_bucket_policy" "cloudtrail_logs_policy" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"],
        Effect = "Allow",
        Resource = [
          "${aws_s3_bucket.cloudtrail_logs.arn}",
          "${aws_s3_bucket.cloudtrail_logs.arn}/*",
        ],
        Principal = "*"
      }
    ]
  })
}
resource "aws_cloudtrail" "cloudtrail_event" {
  name                          = "cloudtrail_event"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.id
  enable_logging                = true
  include_global_service_events = true

  event_selector {
    read_write_type = "All"
    include_management_events = true
  }
}
