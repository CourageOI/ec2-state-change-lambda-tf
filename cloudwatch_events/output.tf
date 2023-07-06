output "cloudwatch_arn" {
  value = aws_cloudwatch_event_rule.ec2_state_change_rule.arn
}