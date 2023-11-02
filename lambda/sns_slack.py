import json
import re
import os
import boto3
import urllib3

# Lambda global variables
region = os.environ["AWS_REGION"]  # from Lambda default envs
slack_url = os.environ["SLACK_URL"]
slack_channel = os.environ["SLACK_CHANNEL"]
slack_user = os.environ["SLACK_USER"]


http = urllib3.PoolManager()
def format_cloudwatch_alarm_message(event):
    alarm_data = json.loads(event['Records'][0]['Sns']['Message'])

    alarm_name = alarm_data["AlarmName"]
    alarm_description = alarm_data["AlarmDescription"]
    new_state = alarm_data["NewStateValue"]
    reason = alarm_data["NewStateReason"]
    metric_name = alarm_data["Trigger"]["MetricName"]
    threshold = alarm_data["Trigger"]["Threshold"]

    message = f"*:exclamation: CloudWatch Alarm Alert :exclamation:*\n\n"
    message += f"  *Alarm Name:* {alarm_name}\n"
    message += f"  *Description:* _{alarm_description}_\n"
    message += f"  *New State:* {new_state}\n"
    message += f"  *Reason:* _{reason}_\n"
    message += f"  *Metric Name:* {metric_name}\n"
    message += f"  *Threshold:* {threshold}\n"

    return message

def lambda_handler(event, context):
    url = slack_url
    msg = {
        "channel": slack_channel,
        "username": slack_user,
        "text": format_cloudwatch_alarm_message(event),
        "icon_emoji": ":cloudwatch:"
    }

    encoded_msg = json.dumps(msg).encode('utf-8')
    resp = http.request('POST', url, body=encoded_msg)

    print({
        "message": msg,
        "status_code": resp.status,
        "response": resp.data
    })
