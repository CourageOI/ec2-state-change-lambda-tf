# main.tf

#sns topic creation and subsription
module "sns" {
    source = "./sns"
    email_address = "osakpolor.ihensekhien@gmail.com"
}

# Calling lambda function module
module "lambda" {
    source = "./lambda"
    sns_topic_arn = module.sns.sns_topic_arn
}

# Calling cloudwatch event module
module "cloudwatch_event" {
    source = "./cloudwatch_events"
    lambda_function_arn = module.lambda.lambda_function_arn
}