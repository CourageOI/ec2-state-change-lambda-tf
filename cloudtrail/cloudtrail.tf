resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "demo-unique-cloudtrail-bucket-name"
  acl    = "private"
}

resource "aws_cloudtrail" "cloudtrail_event" {
  name                          = "cloudtrail_event"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.id
  enable_logging                = true
  include_global_service_events = true

  event_selector {
    read_write_type = "All"
    include_management_events = true
    data_resource {
      type   = "AWS::EC2::Instance"
      values = ["*"]
    }
  }
}
