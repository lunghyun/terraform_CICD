output "instance_id" {
  value = aws_instance.ec2.id
}

output "sg-ec2-comm_id" {
  value = aws_security_group.sg-ec2-comm.id
}

output "instance_az" {
  value = aws_instance.ec2.availability_zone
}