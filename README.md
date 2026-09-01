AWS Cloud Engineering Project - Reliability & Observability Assessment
Project Overview

This project focuses on improving the reliability and observability of a simple cloud-based web service.

The objectives were to:

Deploy a containerised service
Implement monitoring and alerting concepts
Introduce reliability improvements
Simulate and document an incident response scenario

The solution includes:

Containerised frontend and backend services
Frontend to backend communication through AWS Lambda
Infrastructure management using Terraform
AWS service simulation using LocalStack
CI/CD pipeline design and deployment workflow
Tools & Technologies Used
Terraform (Infrastructure as Code)
LocalStack (AWS simulation, free tier)
Docker (containerisation)
React (frontend)
AWS Lambda (backend)
GitHub Pages (frontend hosting)
Node.js (backend runtime)
GitHub Actions (CI/CD pipeline outline)

1. Deploying a Simple Web Service

For this project, I outlined how a CI/CD pipeline would work in a real-world environment.

The pipeline performs the following actions:

Build the frontend application
Package the Lambda function
Run automated tests
Execute Terraform plan and apply
Deploy to either LocalStack or AWS

The frontend was configured to communicate correctly with the backend Lambda function through configurable API endpoints.

2. Monitoring and Observability
Implemented Monitoring

For this project, I implemented basic latency monitoring in the frontend because latency directly affects user experience.

Each API request records:

Start time
End time
Calculated latency

This provides a simple health indicator for backend responsiveness.

The latency measurement logic was added within the frontend application alongside the API request functions.

Proposed Monitoring Enhancements

Due to time constraints, more advanced monitoring features were not implemented.

In a production AWS environment, I would propose using CloudWatch Logs for log collection and exporting logs to Amazon S3 for long-term retention, as S3 is significantly more cost-effective for storing large amounts of historical log data.

Once logs are stored in S3, Amazon Athena could be used to run SQL queries directly against the log files for troubleshooting and analysis without requiring a dedicated database.

Older logs could automatically transition to lower-cost storage tiers such as Amazon Glacier based on retention requirements.

This approach provides a scalable and cost-effective logging solution while making logs easily accessible for investigations and operational support.

In addition, AWS CloudWatch offers advanced capabilities such as:

CloudWatch Dashboards
CloudWatch Anomaly Detection
CloudWatch Alarms

These services enable teams to visualise latency, error rates and overall system health while automatically detecting abnormal application behaviour.

Proposed Database Design

Although the application does not currently require a database, a production implementation could make use of Amazon DynamoDB.

The proposed design would include:

Serverless NoSQL architecture using DynamoDB
Least-privilege IAM permissions
Encryption at rest using AWS KMS
Optional VPC Endpoints for private AWS network traffic

VPC Endpoints provide an additional layer of security by ensuring traffic remains within AWS networks rather than traversing the public internet.

For highly regulated environments handling sensitive information, customer-managed keys and AWS CloudHSM could also be considered to provide greater control over encryption key management.

3. Reliability Improvements

I implemented a simple reliability feature in the frontend using retry logic with exponential backoff.

If an API request fails, for example because of a service delay, temporary outage or Lambda cold start, the frontend automatically retries the request up to three times while increasing the wait time between attempts.

This improves resilience without requiring changes to the backend service.

Implementation

Both API calls use a fetchWithRetry() wrapper instead of the standard fetch() function.

Testing

I tested the solution by:

Stopping LocalStack services
Introducing artificial delays
Forcing request failures

In all scenarios, the retry mechanism behaved as expected and attempted recovery before reporting an error to the user.

References
AWS Documentation: Exponential Backoff and Retry Patterns
AWS Well-Architected Framework - Reliability Pillar
4. Incident Simulation and Response

To validate the reliability controls, I simulated an incident by stopping the backend service, causing API requests to fail.

The frontend retried requests three times using exponential backoff before displaying an error message to the user.

This confirmed that the retry mechanism worked as intended and provided graceful failure handling during service outages.

In a production AWS environment, services such as:

CloudWatch Alarms
CloudWatch Anomaly Detection
AWS X-Ray
CloudTrail Insights

could be used to detect, trace and investigate similar incidents more effectively. These services would provide better visibility and faster root cause analysis in an enterprise environment.
