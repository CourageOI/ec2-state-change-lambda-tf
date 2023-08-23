import boto3
import json

def lambda_handler(event, context):
    sns_client = boto3.client('sns')
    
    for record in event['Records']:
        payload = json.loads(record['Sns']['Message'])
        event_name = payload['detail']['eventName']
        if event_name in ["ModifyInstanceAttribute", "RunInstances", "TerminateInstances", "StopInstances", "CreateInstances"]:
            instance_id = payload['detail']['requestParameters'].get('instancesSet', {}).get('items', [{}])[0].get('instanceId', 'N/A')
            user_identity = payload['detail']['userIdentity']['userName']
            
            message = f"EC2 instance {instance_id} state changed. \nEvent description: {event_name}. \nThis changes was made by: {user_identity}."
            
            response = sns_client.publish(
                TopicArn='your-sns-topic-arn',
                Message=message,
                Subject='EC2 State Change Notification'
            )
            
            print(f"Notification sent: {response['MessageId']}")
            
    return {
        'statusCode': 200,
        'body': json.dumps('Notification sent successfully')
    }