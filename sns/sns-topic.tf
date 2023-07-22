# Create the SNS topic
resource "aws_sns_topic" "ec2_state_change_topic" {
  name = "ec2_state_change_topic"
}

# Add a subscription to the SNS topic for email notifications
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.ec2_state_change_topic.arn
  protocol  = "email"
  endpoint  = var.email_address
}