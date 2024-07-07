# EC2 WordPress Terraform Deployment

This project demonstrates the deployment of a WordPress site on an EC2 instance using Terraform. The configuration creates a public subnet by associating a route table with an Internet Gateway, making the instances in the subnet accessible from the internet. The deployment includes setting up a VPC, subnet, internet gateway, route table, security group, EC2 instance, and an Elastic IP.

# Architecture

[![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://www.linux.org/)
[![Terraform](https://img.shields.io/badge/Terraform-623CE4?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)

![awsstack](./assets/arch.drawio.png)

# Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Terraform Configuration](#terraform-configuration)
4. [Deployment](#deployment)
5. [Accessing WordPress Site](#accessing-wordpress-site)
6. [Cleanup](#cleanup)

## Prerequisites

- Congifured AWS account
- AWS CLI configured with secure credentials
- Terraform installed on local machine
- SSH key pair for EC2 instance access

## Installation

1. Install AWS CLI:

```sh
    sudo apt-get install awscli      # Debian/Ubuntu
    brew install awscli              # macOS
    choco install awscli             # Windows
```

2. Configure AWS CLI:

```sh
    aws configure
    # Requires AWS Access Key, Secret Access Key, Region, Output Format ('json')
```

3. Install Terraform:
   Follow the instructions on the [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) documentation.

## Configuration

1. Clone the repo:

```sh
    git clone https://github.com/sohailsajid79/EC2-WordPress-Terraform-Deployment.git
    cd ec2-wordpress-terraform-deployment
```

2. Update the Terraform configuration (main.tf) with the SSH key pair:

## Deployment

```sh
    terraform init
    # Initialise deployment
```

```sh
    terraform plan
    # Generate and review execution plan
```

```sh
    terraform apply
    # Apply configuration to create the resources in AWS
    # 'yes' to confirm the execution plan
```

## Accessing WordPress Site

1. Access via SSH:

```sh
    ssh -i <key.pem> ec2-user@<public_ip_address>

    # Replace <key.pem> with your key file path and <public_ip_address> with the IP address of your EC2 instance.
```

2. Access WordPress in the browser:

```sh
    http://<public_ip_address>
```

## Cleanup

Avoid incurring charges by destroying the infrastructure when no longer needed:

```sh
    terraform destroy
```
