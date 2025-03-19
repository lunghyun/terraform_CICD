output "ec2-iam-role-profile" {
  value = aws_iam_instance_profile.ec2-iam-role-profile
}
output "ec2-iam-role-name" {
  value = aws_iam_role.ec2-iam-role.name
}