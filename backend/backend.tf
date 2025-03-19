resource "aws_s3_bucket" "terraform_state" { 
  bucket = "mello-terraformstate"
  force_destroy = false
}

resource "aws_s3_bucket_versioning" "enabled" { 
  bucket = aws_s3_bucket.terraform_state.id 
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" { 
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.terraform_state.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "terraform_state_policy" {
  bucket = aws_s3_bucket.terraform_state.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowSpecificRole"
      Effect    = "Allow"
      Principal = { "AWS" : "arn:aws:iam::YOUR_AWS_ACCOUNT_ID:role/YOUR_ROLE_NAME" }
      Action    = [
        "s3:GetBucketPolicy",
        "s3:ListBucket",
        "s3:GetObject",
        "s3:PutObject"
      ]
      Resource = [
        "arn:aws:s3:::mello-terraformstate",
        "arn:aws:s3:::mello-terraformstate/*"
      ]
    }]
  })
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "mello-terraformstate"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}