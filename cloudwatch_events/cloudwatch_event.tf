# Create the CloudWatch Events rule
resource "aws_cloudwatch_event_rule" "ec2_state_change_rule" {
  name        = "ec2_state_change_rule"
  description = "Trigger Lambda function on EC2 state changes"

  event_pattern = <<EOF
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"]
}
EOF
}

# Add the Lambda function as a target for the CloudWatch Events rule
resource "aws_cloudwatch_event_target" "ec2_state_change_target" {
  rule      = aws_cloudwatch_event_rule.ec2_state_change_rule.name
  arn       = var.lambda_function_arn
  target_id = "lambda_target"
}
