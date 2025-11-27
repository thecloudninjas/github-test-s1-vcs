provider "aws" {
  region     = "us-east-1"

  # ✅ Updated with YOUR AWS keys (intentionally misconfigured)
  access_key = "AKIAX24QKKOLD232HO6I"
  secret_key = "Wd2g+5iR8Yawm/oo7JBSTk9jIZ020GP0x0vtUfbu"
}

###########################################################
# Public S3 Bucket (misconfigured)
###########################################################
resource "aws_s3_bucket" "example" {
  bucket = "my-example-bucket"  # ⚠️ Public bucket name may fail if not unique
  acl    = "public-read"        # ❌ Completely public bucket

  tags = {
    Name        = "ExampleBucket"
    Environment = "Development"
  }
}

###########################################################
# Uploading a File Containing Your RSA Private Key
###########################################################
resource "aws_s3_bucket_object" "rsa_private_key_file" {
  bucket  = aws_s3_bucket.example.bucket
  key     = "private-key.pem"

  # ✅ Your full VALID RSA private key added as file content
  content = <<EOF
-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDoUDxJvwjiWsZu
axd1L0mUVkK/KcElPEDdV1VHGL0PZdG+mmurc7bHlKXKMrsdIsQFwWPWlzjQXWuM
snvgfBuy6rjAJeWuauJF/+exmz9XoKB1aFPVjaQviGTdL6nlZ4uQ2xypThb2NrlH
H6e/kUzvNpAeEe+Nd8USNcQkjAeqJwr725+BSnx6tHZoub15MzzocnCQT4wnkYhc
hiKarrFkZR/QQZrjlMbx3Yq948oddYnxe5UE6Ibm9gTBrroYg1TLKhL5UOFEm4gA
/WjhwevfrJwMg/fRmKY+Rp16IM7dizPA2YiGduespmKwjHVjfnjdcyqrVSd+EiES
xYvrjVXzAgMBAAECggEACjSUIW0596+jLfCYbDZylgigEAPGj1sxQkf24BOvIoEH
kMb52eNQcT4Pdm16GNKRJ+uR9jhYb5bbBahFltv834Q+L3q6t0nMvOR8CipWwwO0
aNP3ctcxEkF8pNbWMNS2pdtqS+m5SoGm6//w/5JjfdK4zAlfq6hKSP2Bq1VXdNsC
yux7Spn2hmzlI+9jvb22qUxnhk4yVLRGJD4rzkz79FZruLpt3jfqQR44Q46d7D4Y
n9rAj9+ab4bnfcIoLEaoeGWR2fJcKCzVmkH8JoxuOYHB47HYr2oifsXK8o6dCh20
g5VJtHHq59SFHi716gOp7fMPHYF3KxpVUTAoIMxb6QKBgQD5g7iK4ULpqgcfyieY
R2yu4pNjgkAp6DMGbeNlxKCRiZXC4R2F8SxxHeTSLemt/MyPWJjesimFOARaBzqK
piKWP4LZ2P70k6XkSijdPmWne0JSC+64ZFC7Cbtm3EeJbqtGZqMm1LIZVDHucjc5
NnLmCgTwq5OzP4hzRTsUM71XdwKBgQDuWg7JqIsTF4JAOgtfKJORZpwy9eYRhGfy
XqWUKGnd78L/d1pFFXYTZuntIkK28wrkMZ3DKTS1d7HSJlhFSFV5XG7qNWANuMkF
hInRCXpA100WkQMeahiIVa9ttzraIYmHsQQHBR7C/HlZaoTjK2StF3SIu1MiNbCt
Zp5biNHMZQKBgGr12mA+nG6KYq9v+3U9+QsnOcOIjHTqgyUYakiv950r+7Ukx4Ep
l8GN7Q9key4IlrBEbJPakA35q3PkcWYKPf1mkHNOoEy8Fns8hzQAkZcwMYf2cYk+
B5WGYH2BpHD3rhhp2zrEJuzQuO7cq2utOaf/V4rMIm7Op3GyldbdLyeVAoGBAN2U
ER09NxTnjOmiTEIJWa4ZAuqJGHl+apexjyI9s7VjmBaf4OZKPjtpN9yANh8XsC9V
RMFSRDLS9BdWGEdIKFWrLV1Dg2keOJqNjQUsV1+CB6ML6idTID1V0sEfTnHMLatc
T08rXl6MEU+jq6f4Bh63qFkYM/+gg/+fX2XeupLVAoGBAMb+oj8BH6krY943TDBR
pDAA8UQvslsuulWXeSmh5+ZjOzaLIfjV818aL2h7OE4Fp4H0/oaQX36nQyuTL22U
iYPCuRc1cbt8JfICtkB4/TVE9LbWNgH6aRvP6HCCtNpew/IWS+wR5xXZNdv5Co3A
EXZ136F+Ti9CdVsxwZ3Op+Xn
-----END PRIVATE KEY-----
EOF

  acl = "public-read"   # ❌ Exposing RSA private key publicly
}

###########################################################
# Example Bucket Object
###########################################################
resource "aws_s3_bucket_object" "example_object" {
  bucket  = aws_s3_bucket.example.bucket
  key     = "example-file.txt"
  content = "This is a test file."

  acl = "public-read"  # ❌ Public object
}

###########################################################
# Extremely Open Security Group (misconfiguration)
###########################################################
resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ❌ Wide-open firewall
  }
}
