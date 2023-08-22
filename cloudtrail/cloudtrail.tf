resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "cloudtrail-logs-test"
}

resource "aws_s3_bucket_acl" "cloudtrail_logs_acl" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  # Configure the ACL as needed
  # For example, to make the bucket private:
  grants = [
    {
      type        = "CanonicalUser"
      permissions = ["FULL_CONTROL"]
      id          = aws_canonical_user_id.current.id
    }
  ]
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