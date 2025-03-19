data "aws_subnet" "subnet" {
  id = var.subnet_id
}
locals {
  vpc_id     = data.aws_subnet.subnet.vpc_id
}

##Instance
resource "aws_instance" "ec2" {
  associate_public_ip_address = var.associate_public_ip_address
  ami                  = var.ami #"ami-0f2c95e9fe3f8f80e"
  instance_type        = var.instance_type #"c5.xlarge" "t2.micro"
  iam_instance_profile  = var.ec2-iam-role-profile-name
  vpc_security_group_ids = concat(var.sg_ec2_ids, [aws_security_group.sg-ec2-comm.id])
  subnet_id = var.subnet_id
  source_dest_check = !var.isPortForwarding
  credit_specification {
    cpu_credits = "unlimited"
  }
  root_block_device {
          delete_on_termination = false
          encrypted = true
          kms_key_id = var.kms_key_id
          volume_size = var.ebs_size
  }
  user_data = var.user_data

  key_name = "aws-keypair-${var.stage}-${var.servicename}" 

  tags = merge(tomap({
         Name =  "aws-ec2-${var.stage}-${var.servicename}"}),
        var.tags)

  lifecycle {
    ignore_changes = [user_data,associate_public_ip_address,instance_state]
  }
}

#instance sg
resource "aws_security_group" "sg-ec2-comm" {
  name   = "aws-sg-${var.stage}-${var.servicename}-ec2"
  vpc_id = local.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = var.ssh_allow_comm_list
    description = ""
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(tomap({
         Name = "aws-sg-${var.stage}-${var.servicename}-ec2"}), 
        var.tags)
}