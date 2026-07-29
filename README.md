# 56Bit — AWS Cloud Engineer Assessment - Nua Donaj

## 🌍 Scenario

You've been tasked by the 56Bit engineering team with improving the reliability and observability of a simple web service deployed to the cloud. Your mission is to:
- Deploy a containerised service
- Ensure it is monitored and alertable
- Introduce reliability measures
- Simulate and document an incident and the response

You are required to:
- Containerise and host both the frontend and backend (either locally or in a cloud environment)
- Ensure both services are accessible and can communicate with each other correctly
- The frontend includes a `src/config.js` file where API URLs etc. are configured.
- The frontend must be configured to call the backend Lambda correctly


    Tools & Technologies Used:

    Terraform (Infrastructure as Code)

    LocalStack (AWS simulation, free tier)

    Docker (containerisation)

    React (frontend)

    AWS Lambda (backend)

    GitHub Pages (frontend hosting, provides 60 hours of free credits monthly)

    Node.js (backend runtime)

    GitHub Actions (CI/CD outline)


1. Deploy a Simple Web Service

I outlined how a CI/CD pipeline would work for this project.
It does:

    Build the frontend

    Package the Lambda function

    Run tests

    Run Terraform plan/apply

    Deploy to LocalStack or AWS

2. Set Up Basic Monitoring and Alerting
Implemented Monitoring

For this project, I added a basic latency measurement in the frontend (because frontend display latency which affects user experience). If had accessed to fully paid AWS platform would prefer to use cloudwatch metrics, dashboard and anomoly detection.
Each API request records:

    the start time

    the end time

    the calculated latency

This gives a simple health indicator of backend responsiveness. The code was added in app.js file between the two fetch fucntion


#Proposed solutions that have not been done due to time constraints for Monitoring

In a real AWS environment, I would propose using CloudWatch Logs to collect logs and export them into an S3 bucket, since S3 is much cheaper for long‑term retention. Once logs are stored in S3, they can be analyzed using Amazon Athena, which makes it easy to run SQL queries directly on the log files without loading them into a database. Logs older than a certain period (for example 3 years) can be automatically moved to a cheaper storage tier such as Glacier, depending on retention needs. Storing logs in S3 also makes it easy to share them with engineers for troubleshooting and investigations, which is an important component in any IT infrastructure.

In addition, AWS offers more advanced CloudWatch capabilities such as Anomaly Detection, which automatically learns normal application behaviour and alerts when metrics deviate from expected patterns, and CloudWatch Dashboards, which allow teams to visualise latency, error rates, and system health in real time. 

#Proposed solutions that have not been done due to time constraints for choosing and using a Database

In a real AWS environment, I would deploy a serverless NoSQL DynamoDB table, secured through strict least‑privilege IAM access, encrypted at rest with AES‑256 via KMS, and optionally accessed through a VPC endpoint for private network traffic. VPC endpoint is cheap and ensures traffic does not bypass the internet. In case of highly sensitive HIPA regulated bussiness Customer keys adn CloudHSM can also be levereged to ensure not even AWS has the decryption keys and data can be enrypted before.

3. Add Reliability Features


I added a simple reliability feature to the frontend: retry logic with exponential backoff.
If an API request fails (e.g., LocalStack delay, Lambda cold start), the frontend automatically retries the request up to 3 times, waiting slightly longer each time.

This improves resilience without changing the backend.

Where implemented:  
Both API calls now use a fetchWithRetry() wrapper instead of fetch().

How tested:  
I simulated failures by stopping LocalStack, adding delays in Lambda, and forcing errors.
The frontend retried the requests correctly in all cases.

Resources used:  
AWS documentation on the exponential backoff reliability pattern and the AWS Well‑Architected Reliability Pillar.


4. I simulated an incident by stopping the LocalStack container, causing the backend API to become unavailable. The frontend retried the request three times using exponential backoff, then returned an error message. This confirmed that the reliability feature works as expected.

In a real AWS environment, premium services such as CloudWatch Alarms, CloudWatch Anomaly Detection, AWS X-Ray, and CloudTrail Insights could be used to detect, trace, and analyze similar incidents. This solution would be more good for enteprise version.
