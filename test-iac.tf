###############################################
# SUPER MISCONFIGURED TERRAFORM FOR TESTING
###############################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  # ❌ Hardcoded credentials (bad)
  access_key = "AKIAX24QKKOLD232HO6I"
  secret_key = "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"
}

###############################################################
# 1. PUBLIC S3 BUCKET WITH NO ENCRYPTION + PUBLIC READ/WRITE
###############################################################

resource "aws_s3_bucket" "public_bucket" {
  bucket = "misconfigured-iac-public-bucket-example"

  # ❌ No encryption block
  # ❌ No ACL security
}

resource "aws_s3_bucket_public_access_block" "public_block" {
  bucket = aws_s3_bucket.public_bucket.id

  # ❌ Everything disabled
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.public_bucket.id

  # ❌ Full public read + write (VERY BAD)
  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[{
    "Effect":"Allow",
    "Principal": "*",
    "Action":["s3:*"],
    "Resource":[
      "${aws_s3_bucket.public_bucket.arn}",
      "${aws_s3_bucket.public_bucket.arn}/*"
    ]
  }]
}
EOF
}

###############################################################
# 2. OVER-PERMISSIVE IAM ROLE (admin everywhere)
###############################################################

resource "aws_iam_role" "over_permissive_role" {
  name = "misconfigured-admin-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {"Service": "ec2.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }]
}
EOF
}

resource "aws_iam_role_policy" "admin_policy" {
  name = "full-admin-policy"
  role = aws_iam_role.over_permissive_role.id

  # ❌ Wildcard admin policy
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement":[{
    "Effect":"Allow",
    "Action":"*",
    "Resource":"*"
  }]
}
EOF
}

###############################################################
# 3. SECURITY GROUP WITH OPEN PORT 22 / 80 / 443 TO WORLD
###############################################################

resource "aws_security_group" "insecure_sg" {
  name        = "insecure-sg"
  description = "Open to the world"
  vpc_id      = "vpc-123456" # ❌ Hardcoded VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ❌ SSH open to world
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ❌ Wide open
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ❌ Wide open
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # ❌ Allow all egress
  }
}

###############################################################
# 4. EC2 INSTANCE WITH USER DATA LEAKING SECRETS
###############################################################

resource "aws_instance" "bad_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.insecure_sg.id]

  # ❌ Hardcoded creds inside user data (leaks to metadata logs)
  user_data = <<EOF
#!/bin/bash
echo "API_KEY=sk_live_fake_example_123456789" >> /etc/environment
echo "DB_PASSWORD=SuperInsecurePassword123!" >> /etc/environment
EOF

  # ❌ No IAM role attached
  # ❌ No encryption configurations
  # ❌ Public IP enabled by default
}

###############################################################
# 5. KUBERNETES SECRET INSIDE TERRAFORM WITH PLAINTEXT KEYS
###############################################################

resource "kubernetes_manifest" "secret_test" {
  manifest = {
    apiVersion = "v1"
    kind       = "Secret"
    metadata = {
      name = "hardcoded-secret"
    }
    type = "Opaque"
    stringData = {
      aws_key               = "AKIAX24QKKOLD232HO6I"
      aws_secret            = "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"

      rsa_private_key = <<-EOF
      -----BEGIN PRIVATE KEY-----
      MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEA...
      -----END PRIVATE KEY-----
      EOF
    }
  }
}
