The backend is implemented as an AWS Lambda function written in Python.

Components:

- `lambda_function.py` - Contains the Lambda function logic and API response handling.
- `requirements.txt` - Python dependencies required by the application.
- `Dockerfile` - Container configuration used for local development and testing.

The backend follows a serverless architecture and is deployed using Terraform. LocalStack is used to simulate AWS services during development and testing.
