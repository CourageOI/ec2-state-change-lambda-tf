# main.tf

#sns topic creation and subsription
module "sns" {
    source = "./sns"
    email_address = "osakpolor.ihensekhien@gmail.com"
}


# Calling cloudtrail resource
module "lambda" {
    source = "./cloudtrail"
}
# Calling lambda function module
module "lambda" {
    source = "./lambda"
    sns_topic_arn = module.sns.sns_topic_arn
    cloudwatch_arn = module.cloudwatch_event.cloudwatch_arn
}

# Calling cloudwatch event module
module "cloudwatch_event" {
    source = "./cloudwatch_events"
    lambda_function_arn = module.lambda.lambda_function_arn
}