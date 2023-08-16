resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "your-unique-cloudtrail-bucket-name"
}

resource "aws_s3_bucket_acl" "cloudtrail_logs_acl" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  grants = [
    {
      id          = "canonical_user_id"
      permissions = ["FULL_CONTROL"]
    }
  ]
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
