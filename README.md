# Project 1 – AWS EC2 Web Server using Terraform

[![Terraform CI Validation](https://github.com/aryan-singh-acc/project-01-ec2-terraform/actions/workflows/terraform-ci.yml/badge.svg)](https://github.com/aryan-singh-acc/project-01-ec2-terraform/actions/workflows/terraform-ci.yml)

## Overview

This project demonstrates Infrastructure as Code (IaC) using Terraform to provision an AWS EC2 web server inside a custom Virtual Private Cloud (VPC).

An Ubuntu 24.04 EC2 instance is configured to install and run Apache automatically using a startup script (user data).

## Architecture

The infrastructure consists of:

- Amazon VPC
- Public subnet
- Internet Gateway
- Public route table and subnet association
- Security group
- Ubuntu 24.04 EC2 instance
- Apache HTTP web server

## Technology Stack

- AWS
- Terraform
- Ubuntu Linux 24.04
- Apache HTTP Server
- Git and GitHub

## Configuration

| Component | Configuration |
|---|---|
| AWS Region | us-east-2 |
| Instance type | t3.micro |
| Operating system | Ubuntu 24.04 |
| VPC CIDR | 10.50.0.0/16 |
| Subnet CIDR | 10.50.1.0/24 |
| Root volume | 8 GB gp3 |
| Web server | Apache |
| HTTP port | 80 |

## Project Structure

```text
project-01-ec2-terraform/
├── evidence/
│   ├── SS_APPLY.png
│   ├── Webpage screen shot.png
│   └── ec2.png
├── .gitignore
├── .terraform.lock.hcl
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md
```

## Deployment Instructions

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Validate the configuration

```bash
terraform validate
```

### 3. Review the execution plan

```bash
terraform plan
```

### 4. Deploy the infrastructure

```bash
terraform apply
```

Review the plan and confirm before applying.

### 5. Access the website

After deployment, Terraform provides the EC2 public IP and website URL as outputs.

Open the website URL in a browser to access the Apache web page.

## Security Considerations

- AWS credentials are not stored in the repository.
- Terraform state and plan files are excluded through `.gitignore`.
- The security group permits HTTP traffic on port 80.
- SSH access is intentionally not enabled in this demonstration.
- The root EBS volume uses gp3 storage.

## Cleanup

After testing, remove the infrastructure using:

```bash
terraform destroy
```

Review the destroy plan before confirming.

## Evidence

The `evidence/` directory contains screenshots of:

- Successful Terraform deployment
- EC2 instance configuration
- Deployed Apache web page

## Learning Outcomes

- Understanding Infrastructure as Code.
- Provisioning AWS resources using Terraform.
- Configuring VPC networking.
- Deploying an EC2 instance.
- Automating Apache installation using user data.
- Managing infrastructure configuration through Git.

## Author

Aryan Singh
