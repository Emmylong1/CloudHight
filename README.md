# - Build a CI/CD Pipeline to deploy a java application into a Highly Available Docker Host Environment on AWS.

- This project involves setting up AWS infrastructure using Terraform and implementing a CI/CD pipeline with Jenkins for a Java application. The infrastructure includes a custom VPC, Auto Scaling Group, and Load Balancer for high availability. The CI/CD pipeline automates the build, testing, and deployment of the application. Key considerations include security, monitoring, backup, and cost optimization.
## Planning and Design:
- Define project requirements and architecture, including VPC layout, subnetting, availability zones, and security considerations.
- Determine resource requirements such as EC2 instance types, load balancer type, and IAM roles.

## Table of Contents
- [Infrastructure Provisioning](#Infrastructure-Provisioning)
- [Containerization](#containerization)
- [CI/CD Pipeline Setup](#CI/CD-Pipeline-Setup)
- [Additional Considerations](#Additional-Considerations)
- [Communication](#Communication)
- [References](#References)

## Install Required Tools
- <a href="https://developer.hashicorp.com/terraform/install?product_intent=terraform">Install Terraform on a local machine.</a>
- <a href="https://docs.docker.com/engine/install/">Install Docker by following the instructions.</a>
- <a href="https://medium.com/@emmanuelibok505/how-to-set-up-an-aws-command-line-interface-cli-profile-for-an-iam-user-772b942956f">Configure AWS credentials for Terraform to access AWS services.</a>
- <a href="https://pkg.jenkins.io/debian-stable/">checkout jenkins documetation</a>

## Terraform Configuration:
- Write Terraform configuration files (.tf) to define infrastructure resources.
- Define custom VPC with public and private subnets across multiple availability zones.
- Configure security groups to allow necessary traffic.
- Define Auto Scaling Group to launch EC2 instances within private subnets.
- Configure Load Balancer (ELB or ALB) to distribute traffic across EC2 instances.

## Apply Terraform Configuration:
- Run ``terraform init`` to initialize the working directory.
- Run ``terraform plan`` to preview the changes.
- Run ``terraform apply or -auto-approve`` to apply the changes and provision the infrastructure.

## IAM Role Configuration:
- Define IAM roles with appropriate permissions for EC2 instances and Auto Scaling Group.
- Attach IAM roles to EC2 instances and Auto Scaling Group.
- After launching your resource on AWS, you need to SSH into your jump server and then provide your private key to access your Docker private host. It's important to note that your jump server and Docker private host must be on the same network.


## CI/CD Pipeline Setup Process:
### Select CI/CD Tool:
- Choose Jenkins or another CI/CD tool based on project requirements and familiarity.
- For this project, we have opted for Jenkins as our CI/CD tool.
- Install Jenkins on a server or utilize a cloud-based CI/CD service.
- Set up necessary plugins or integrations for GitHub and Docker.
### Configure Jenkins Pipeline:
- Create a Jenkins pipeline job.
- Configure the pipeline to fetch the Java application source code from the specified GitHub repository.
- Set up stages within the pipeline to build the Java application and package it into a Docker container.
### Configure GitHub Webhook
- This trigger the pipeline automatically upon changes to the GitHub repository.
- Go to your GitHub repository > Settings > Webhooks.
- Click on "Add webhook".
- Set the Payload URL to http://your-jenkins-server/github-webhook/.
- Choose "application/json" as the content type.
- Select "Just the push event".
- Click on "Add webhook" to save.

### Create a dockerfile in your application root
``FROM maven:3.8.4-openjdk-11 AS build

WORKDIR /app

COPY pom.xml .

COPY .mvn ./.mvn
COPY src ./src
COPY target ./target

RUN mvn clean package -DskipTests

FROM adoptopenjdk/openjdk11:alpine-slim

WORKDIR /app

COPY --from=build /app/target/*.war ./cloudhight.war

EXPOSE 8085

CMD ["java", "-jar", "cloudhight.war"]


### Deploy Docker Container
- Configure the pipeline to deploy the Docker container onto the Docker hosts provisioned earlier.
- Use appropriate deployment scripts or commands to manage container deployment.
### Implement Continuous Deployment:
- Set up a webhook or polling mechanism in Jenkins to trigger the pipeline automatically upon changes to the GitHub repository.
Ensure proper testing and approval processes are integrated into the pipeline to maintain quality control.