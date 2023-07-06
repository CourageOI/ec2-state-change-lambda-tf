# Create the IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda_ec2_state_change_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach the necessary IAM policy for SNS to the role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
  role       = aws_iam_role.lambda_role.name
}

# Create the Lambda function
resource "aws_lambda_function" "ec2_state_change_lambda" {
  function_name    = "ec2_state_change_notification"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
  role             = aws_iam_role.lambda_role.arn

   # Add the CloudWatch Events trigger
  event_source_token = var.cloudwatch_arn
  depends_on = [aws_cloudwatch_event_rule.ec2_state_change_rule]

  # Add environment variables
  environment {
    variables = {
      SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }
}

