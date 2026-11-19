
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 7.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Capstone-Project-1"
      Environment = "Capstone"
      ManagedBy   = "Terraform"
    }
  }
}

# Get the latest Ubuntu 24.04 AMI
data "aws_ssm_parameter" "ubuntu" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

# 1. Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# 2. Create Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

# 3. Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# 4. Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-route-table"
  }
}

# 5. Associate Route Table with Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# 6. Security Group
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-security-group"
  }
}

# 7. EC2 Instance
resource "aws_instance" "web_server" {
  ami                         = data.aws_ssm_parameter.ubuntu.value
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y apache2

    systemctl enable apache2
    systemctl start apache2

    cat > /var/www/html/index.html <<'HTML'
    <!DOCTYPE html>
    <html>
    <head>
      <title>Terraform EC2 Web Server</title>
      <style>
        body {
          font-family: Arial, sans-serif;
          text-align: center;
          background: #eef2f7;
          padding: 80px;
        }
        .container {
          background: white;
          padding: 40px;
          border-radius: 12px;
          max-width: 650px;
          margin: auto;
          box-shadow: 0 4px 15px #0002;
        }
        h1 { color: #232f3e; }
        p { color: #444; font-size: 18px; }
      </style>
    </head>
    <body>
      <div class="container">
        <h1>Welcome to My AWS EC2 Web Server!</h1>
        <p>Successfully deployed using Terraform.</p>
        <p>Web Server: Ubuntu Linux</p>
        <p>Web Server Software: Apache</p>
        <p>Cloud Platform: Amazon Web Services</p>
      </div>
    </body>
    </html>
    HTML
  EOF

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_name}-ec2"
  }
}
