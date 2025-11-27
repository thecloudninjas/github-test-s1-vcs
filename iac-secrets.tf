terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "local" {}

resource "local_file" "secret_detector_test" {
  filename = "secret-detector-test.txt"

  content = <<-EOT
Valid Key (rsa_private.pem)
apiVersion: v1
kind: Secret
metadata:
  name: secret-detector-test
  namespace: default
type: Opaque
stringData:

aws_access_key_id = AKIAX24QKKOLD232HO6I
aws_secret_access_key = Wd2g+5iR8Yawm/oo7JBSTk9jIZ020GP0x0vtUfbu
output = json
region = us-east-2


Not a Valid Key (Sample Key)
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAuFakeTestKeyMaterialOnlyForSecretScanning123456789
b3BlbmFJQ19zZWNyZXRfZGV0ZWN0b3JfdGVzdF9rZXlfbWF0ZXJpYWwK
-----END RSA PRIVATE KEY-----

Valid Key (rsa_public.pem)
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6FA8Sb8I4lrGbmsXdS9J
lFZCvynBJTxA3VdVRxi9D2XRvpprq3O2x5SlyjK7HSLEBcFj1pc40F1rjLJ74Hwb
suq4wCXlrmriRf/nsZs/V6CgdWhT1Y2kL4hk3S+p5WeLkNscqU4W9ja5Rx+nv5FM
7zaQHhHvjXfFEjXEJIwHqicK+9ufgUp8erR2aLm9eTM86HJwkE+MJ5GIXIYimq6x
ZGUf0EGa45TG8d2KvePKHXWJ8XuVBOiG5vYEwa66GINUyyoS+VDhRJuIAP1o4cHr
36ycDIP30ZimPkadeiDO3YszwNmIhnbnrKZisIx1Y3543XMqq1UnfhIhEsWL641V
8wIDAQAB
-----END PUBLIC KEY-----


Valid Key (rsa_private.pem)
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
EOT
}
