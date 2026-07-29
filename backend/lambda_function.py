import json
import requests

def lambda_handler(event, context):
    api_key = event.get('headers', {}).get('x-api-key', '')
    if api_key != 'super-secret-key-dont-show-anyone-pls':
        return {
            'statusCode': 403,
            'headers': {'Content-Type': 'application/json'},
            'body': json.dumps({'error': 'Forbidden: Invalid API key'})
        }

    response = requests.get('https://jsonplaceholder.typicode.com/posts/5')
    api_data = response.json()

    return {
        'statusCode': 200,
        'headers': {'Content-Type': 'application/json'},
        'body': json.dumps({
            'message': 'Hello from Lambda!',
            'receivedApiKey': api_key,
            'externalApiData': api_data
        })
    }
