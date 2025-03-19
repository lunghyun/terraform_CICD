output "rds-random-password" {
  value     = random_password.rds-password.result
  sensitive = true
}
output "endpoint" {
  value     = aws_rds_cluster.rds-cluster.endpoint
}
output "ro_endpoint" {
  value     = aws_rds_cluster.rds-cluster.reader_endpoint
}