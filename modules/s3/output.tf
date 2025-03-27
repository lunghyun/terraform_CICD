output "cloudfront_domain" {
  value = aws_cloudfront_distribution.frontend.domain_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.frontend.bucket
}