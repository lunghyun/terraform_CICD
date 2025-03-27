provider "aws" {
  region = var.region # Please use the default region ID
}

# 버지니아 북부 - CloudFront용 인증서
resource "aws_acm_certificate" "cloudfront_cert" {
  provider          = aws.us_east
  domain_name       = "hellomello.site"
  subject_alternative_names = ["*.hellomello.site"]
  validation_method = "DNS"
}