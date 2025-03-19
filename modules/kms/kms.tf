resource "aws_kms_key" "rds-kms-key" {
  description             = "This key is used to encrypt rds ${var.stage}-${var.servicename}"
  enable_key_rotation     = true
  deletion_window_in_days = 10
  tags = merge(tomap({
         Name = "aws-kms-${var.stage}-${var.servicename}-rds"}),
         var.tags)
}

resource "aws_kms_alias" "rds-comm-kms-key-alias" {
  name          = "alias/aws-kms-${var.stage}-${var.servicename}-rds"
  target_key_id = aws_kms_key.rds-kms-key.key_id
}
