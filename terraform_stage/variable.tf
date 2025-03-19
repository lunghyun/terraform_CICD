variable "region" {
  type = string
  default = "ap-northeast-2"
}
variable "stage" {
  type = string
  default = "stage"
}
variable "servicename" {
  type = string
  default = "terraform_jung9546"
}
variable "tags" {
  type = map(string)
  default = {
    "name" = "jung9546_VPC"
  }
}

#VPC
variable "az" {
  type = list(any)
  default = [ "ap-northeast-2a", "ap-northeast-2c" ]
}
variable "vpc_ip_range" {
  type = string
  default = "10.2.92.0/24"
}

variable "subnet_public_az1" {
  type = string
  default = "10.2.92.0/27"
}
variable "subnet_public_az2" {
  type = string
  default = "10.2.92.32/27"
}

variable "subnet_service_az1" {
  type = string
  default = "10.2.92.64/26"
}
variable "subnet_service_az2" {
  type = string
  default = "10.2.92.128/26"
}

variable "subnet_db_az1" {
  type = string
  default = "10.2.92.192/27"
}

variable "subnet_db_az2" {
  type = string
  default = "10.2.92.224/27"
}
# variable "create_tgw" {
#   type = bool
#   default = false
# }
# variable "ext_vpc_route" {
#   type = any
# }
# variable "security_attachments" {
#   type = any
# }
# variable "security_attachments_propagation" {
#   type = any
# }
# variable "tgw_sharing_accounts" {
#   type = map
# }


##Instance
variable "ami"{
  type = string
  default = "ami-04c596dcf23eb98d8"
}
variable "instance_type" {
  type = string
  default = "t2.micro"
}
variable "instance_ebs_size" {
  type = number
  default = 20
}
variable "instance_ebs_volume" {
  type = string
  default = "gp3"
}

# variable "instance_user_data" {
#   type = string
# }
# variable "redis_endpoints" {
#   type = list
# }

##RDS
variable "rds_dbname" {
  type = string
  default = "jung9546"
}
variable "rds_instance_count" {
  type = string
  default = "2"
}
variable "sg_allow_ingress_list_aurora"{
  type = list
  default = ["10.2.92.64/26", "10.2.92.128/26", "10.2.92.18/32"]
}
variable "associate_public_ip_address" {
  type = bool
  default = true
}

##KMS
variable "rds_kms_arn" {
  type = string
  default = "arn:aws:kms:ap-northeast-2:471112992234:key/1dbf43f7-1847-434c-bc3c-1beb1b86e480"
}
variable "ebs_kms_key_id" {
  type = string
  default = "arn:aws:kms:ap-northeast-2:471112992234:key/43b0228d-0a06-465c-b25c-7480b07b5276"
}