provider "aws" {
  region = "us-east-1"
  access_key = "AKIAT4GVSAXXDGNRNT7U"  # ❌ Hardcoded AWS access key
  secret_key = "PI1GH82AHTEOzytNKSfe5vd14uRHGwhkWAvylrwi"  # ❌ Hardcoded AWS secret key
}

resource "aws_s3_bucket" "example" {
  bucket = "my-example-bucket"  # ⚠️ Make sure the bucket name is globally unique
  acl    = "public-read"        # ❌ Public access granted, exposing bucket contents

  tags = {
    Name        = "ExampleBucket"
    Environment = "Development"
  }
}

resource "aws_s3_bucket_object" "example_object" {
  bucket = aws_s3_bucket.example.bucket
  key    = "example-file.txt"
  content = "This is a test file."

  acl    = "public-read"  # ❌ Exposing the file publicly
}

resource "aws_security_group" "example" {
  name = "example-sg"
  description = "Allow all inbound traffic"

  # Security group with open inbound rules (misconfiguration)
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ⚠️ Allowing access from anywhere
  }
}
