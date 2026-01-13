terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

#################################
# Provider with hardcoded secrets
#################################
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA1234567890EXAMPLE"   # ❌ Hardcoded credentials
  secret_key = "secretkey1234567890"     # ❌ Hardcoded credentials
}

#################################
# Public S3 bucket with no security
#################################
resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "checkmarx-insecure-bucket-123"

  acl    = "public-read"  # ❌ Public bucket

  versioning {
    enabled = false       # ❌ No versioning
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256" # ❌ No KMS
      }
    }
  }

  logging {
    target_bucket = null   # ❌ No access logging
  }
}

#################################
# Public EC2 instance
#################################
resource "aws_instance" "insecure_ec2" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"

  associate_public_ip_address = true   # ❌ Public IP exposed

  user_data = <<EOF
#!/bin/bash
echo "root:password123" | chpasswd   # ❌ Weak credentials
EOF

  tags = {
    Name = "InsecureEC2"
  }
}

#################################
# Overly permissive security group
#################################
resource "aws_security_group" "open_sg" {
  name        = "open-security-group"
  description = "Allow all traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"               # ❌ Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]       # ❌ Open to the world
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]       # ❌ Unrestricted outbound
  }
}

#################################
# IAM policy with admin access
#################################
resource "aws_iam_policy" "admin_policy" {
  name        = "admin-policy"
  description = "Full admin access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "*"
      Resource = "*"                # ❌ Full admin permissions
    }]
  })
}

#################################
# RDS without encryption or backup
#################################
resource "aws_db_instance" "insecure_db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "testdb"
  username             = "admin"
  password             = "admin123"   # ❌ Weak hardcoded password
  skip_final_snapshot  = true          # ❌ No snapshot
  storage_encrypted    = false         # ❌ No encryption
  publicly_accessible  = true          # ❌ Public database
}
