# Output the SNS topic ARN
output "sns_topic_arn" {
  value = aws_sns_topic.ec2_state_change_topic.arn
}