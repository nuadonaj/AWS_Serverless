import json
import requests
import os

def lambda_handler(event, context):
    """
    Lambda handler for backend API
    Authenticates using x-api-key header and proxies to external API
    """
    
    # Check x-api-key header (matches frontend configuration)
    auth_header = event.get("headers", {}).get("x-api-key", "")
    expected_key = os.environ.get("API_KEY", "")
    
    if not auth_header or auth_header != expected_key:
        return {
            "statusCode": 403,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({
                "message": "Access denied - invalid or missing API key"
            })
        }
    
    try:
        response = requests.get(
            "https://jsonplaceholder.typicode.com/todos/1",
            timeout=5
        )
        response.raise_for_status()
        
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
    
    except requests.exceptions.RequestException as e:
        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({
                "message": "Internal server error",
                "error": str(e)
            })
        }
