# lambda_function.py

import json
import boto3
import os

def lambda_handler(event, context):
 
  sns_client = boto3.client('sns')

  # Get the details of the EC2 instance state change from the event.
  instance_id = event['detail']['instance-id']
  state = event['detail']['state']
  user_name = event['detail']

  # Get the SNS topic ARN from the environment variable.
  sns_topic_arn = os.environ['SNS_TOPIC_ARN']

  # Send an email notification with the details of the EC2 instance state change.
  message = f'EC2 instance {instance_id} has changed state to {state}.\n\n' \
           f'This change was made by user {user_name}.'
  sns_client.publish(
    TopicArn=sns_topic_arn,
    Message=message
  )

  return {
    'statusCode': 200,
    'body': json.dumps('Successfully sent email notification.')
  }

