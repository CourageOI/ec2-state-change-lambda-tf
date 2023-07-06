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
    cloudwatch_arn = module.cloudwatch_event.cloudwatch_arn
    depends_on = [module.cloudwatch_event.aws_cloudwatch_event_rule.ec2_state_change_rule]
}



# Calling cloudwatch event module
module "cloudwatch_event" {
    source = "./cloudwatch_events"
    lambda_function_arn = module.lambda.lambda_function_arn
}