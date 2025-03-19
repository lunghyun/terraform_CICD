variable "stage" {
  type  = string
  default = "dev"
}
variable "servicename" {
  type  = string
  default = "jung9546"
}
variable "tags" {
  type = map(string)
  default = {
    "name" = "jung9546-EC2"
  }
}

variable "ami" {
  type  = string
  default = "ami-04c596dcf23eb98d8" #AL2
}
variable "instance_type" {
  type  = string
  default = "t2.micro" #1c1m
}
variable "sg_ec2_ids" {
  type  = list
}
variable "subnet_id" {
  type  = string
}
variable "vpc_id" {
  type  = string
  default = ""
}
variable "ebs_size" {
  type = number
  default = 50
}
variable "user_data" {
  type = string
  default = ""
}
variable "kms_key_id" {
  type = string
}
variable "ec2-iam-role-profile-name" {
  type = string
}
variable "associate_public_ip_address" {
  type = bool
  default = false
}
variable "isPortForwarding" {
  type = bool
  default = false
}
variable "ssh_allow_comm_list" {
  type = list(any)
}