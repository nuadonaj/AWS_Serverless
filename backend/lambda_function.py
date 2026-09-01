import json
import requests

def lambda_handler(event, context):

    auth_header = event.get("headers", {}).get("Authorization", "")

    if auth_header != "demo-api-key":
        return {
            "statusCode": 403,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({
                "message": "Access denied"
            })
        }

    response = requests.get(
        "https://jsonplaceholder.typicode.com/todos/1",
        timeout=5
    )

    data = response.json()

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({
            "service": "Cloud Reliability Project",
            "status": "healthy",
            "data": data
        })
    }
