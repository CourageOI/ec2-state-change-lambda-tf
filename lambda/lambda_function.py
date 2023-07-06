# lambda_function.py

import json
import boto3
import os

def lambda_handler(event, context):
    # Extract relevant information from the event
    instance_id = event['detail']['instance-id']
    state = event['detail']['state']
    username = event['detail']['userIdentity']['userName']

    # Retrieve the SNS topic ARN from the environment variable
    sns_topic_arn = os.environ['SNS_TOPIC_ARN']

    # Create an SNS client
    sns_client = boto3.client('sns')

    # Publish a message to the SNS topic
    message = f"EC2 instance {instance_id} state changed to {state} by {username}"
    sns_client.publish(
        TopicArn=sns_topic_arn,
        Message=message
    )

    return {
        'statusCode': 200,
        'body': json.dumps('Notification sent successfully')
    }
