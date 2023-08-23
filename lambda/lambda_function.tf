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

# zip the python file
data "archive_file" "zip_lambda" {
type        = "zip"
source_dir  = "${path.module}/python_code"
output_path = "${path.module}/python/lambda_function.zip"
}
# Create the Lambda function
resource "aws_lambda_function" "ec2_state_change_lambda" {
  function_name    = "ec2_state_change_notification"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.10"
  filename         = "${path.module}/python/lambda_function.zip"
  source_code_hash = data.archive_file.zip_lambda.output_base64sha256
  role             = aws_iam_role.lambda_role.arn

  # Add environment variables
  environment {
    variables = {
      SNS_TOPIC_ARN = var.sns_topic_arn
    }
  }
  publish = true
}

