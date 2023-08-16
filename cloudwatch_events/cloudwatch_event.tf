# Create the CloudWatch Events rule
resource "aws_cloudwatch_event_rule" "ec2_state_change_rule" {
  name        = "ec2_state_change_rule"
  description = "Trigger Lambda function on EC2 state changes"

  event_pattern = jsonencode({
    source      = ["aws.cloudtrail"]
    detail_type = ["AWS API Call via CloudTrail"]
    detail      = {
      eventSource = ["ec2.amazonaws.com"]
      eventName   = ["ModifyInstanceAttribute", "RunInstances", "TerminateInstances", "StopInstances", "CreateInstances"]
    }
  })
}

resource "aws_cloudwatch_event_target" "ec2_state_change_target"{
  rule      = aws_cloudwatch_event_rule.ec2_state_change_rule.name
  arn       = var.lambda_function_arn
  target_id = "lambda_target"
}