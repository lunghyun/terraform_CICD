terraform {
 required_version = ">= 1.0.0, < 2.0.0"

  backend "s3" {
    bucket = "jung9546-terraformstate"
    key  = "dev/terraform/terraform.tfstate"
    region = "ap-northeast-2"
    encrypt = true
    dynamodb_table = "jung9546-terraform-state"
  }
}

##Sharedservic resources
module "vpc" {
  source              = "../modules/vpc"

  stage       = var.stage
  servicename = var.servicename
  tags        = var.tags
  # region     = var.region
  # kms_arn = var.s3_kms_key_id

  vpc_ip_range = var.vpc_ip_range
  az           = var.az

  subnet_public_az1 = var.subnet_public_az1
  subnet_public_az2 = var.subnet_public_az2
  subnet_service_az1 = var.subnet_service_az1
  subnet_service_az2 = var.subnet_service_az2
  subnet_db_az1  = var.subnet_db_az1
  subnet_db_az2  = var.subnet_db_az2
 
  ##SecurityGroup
  #sg_allow_comm_list = concat(var.ext_sg_allow_list, ["${module.vpc.nat_ip}/32", var.vpc_ip_range])

  ##TGW
  #create_tgw = var.create_tgw
  #tgw_sharing_accounts = var.tgw_sharing_accounts
#   ext_vpc_route = var.ext_vpc_route
  #security_attachments = var.security_attachments
  #auto_accept_shared_attachments = true
  #security_attachments_propagation = merge(var.security_attachments_propagation, var.security_attachments)
}

# module "jung9546-ec2" {
#   source              = "../modules/instance"

#   stage        = var.stage
#   servicename  = "${var.servicename}"
#   tags         = var.tags

#   ami                       = var.ami
#   instance_type             = var.instance_type
#   ebs_size                  = var.instance_ebs_size
#   #user_data                 = var.instance_user_data
#   kms_key_id                = var.ebs_kms_key_id
#   ec2-iam-role-profile-name = module.iam-service-role.ec2-iam-role-profile.name
#   ssh_allow_comm_list       = [var.subnet_service_az1, var.subnet_service_az2]

#   associate_public_ip_address = var.associate_public_ip_address

#   subnet_id = module.vpc.public-az1.id
#   vpc_id    = module.vpc.vpc_id
#   user_data = <<-EOF
# #!/bin/bash 
# yum update -y 
# yum install -y https://s3.ap-northeast-2.amazonaws.com/amazon-ssm-ap-northeast-2/latest/linux_amd64/amazon-ssm-agent.rpm
# EOF
#   ##SecurityGroup
#   sg_ec2_ids = [aws_security_group.sg-ec2.id]
#   #depends_on = [module.vpc.sg-ec2-comm, module.iam-service-role.ec2-iam-role-profile]
# }

# resource "aws_security_group" "sg-ec2" {
#   name   = "aws-sg-${var.stage}-${var.servicename}-ec2"
#   vpc_id = module.vpc.vpc_id

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "TCP"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = ""
#   }
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "TCP"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = ""
#   }
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "TCP"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = ""
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = merge(tomap({
#          Name = "aws-sg-${var.stage}-${var.servicename}-ec2"}), 
#         var.tags)
# }

#RDS
# module "rds" {
#   #default engin aurora-mysql8.0
#   source       = "../modules/aurora"
#   stage        = var.stage
#   servicename  = var.servicename
  
#   tags = var.tags
#   dbname = var.rds_dbname
 
# #  sg_allow_ingress_list_aurora    = var.sg_allow_ingress_list_aurora
# #  sg_allow_ingress_sg_list_aurora = concat([module.vpc.sg-ec2-comm.id, module.eks.eks_node_sg_id], var.sg_allow_list_aurora_sg_add)
#   sg_allow_ingress_list_aurora = var.sg_allow_ingress_list_aurora
#   network_vpc_id                  = module.vpc.network-vpc.id
#   subnet_ids = [module.vpc.db-az1.id, module.vpc.db-az2.id]
#   az           = var.az

#   rds_instance_count = var.rds_instance_count

#   kms_key_id = var.rds_kms_arn
#   depends_on = [module.vpc]
# }
